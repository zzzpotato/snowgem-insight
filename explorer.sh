#!/usr/bin/env bash

D=$PWD

#sudo apt-get install \
#      build-essential pkg-config libc6-dev m4 g++-multilib \
#      autoconf libtool ncurses-dev unzip git python python-zmq \
#      zlib1g-dev wget bsdmainutils automake curl

# build zend patched with addressindexing support
#git clone https://github.com/snowgem/snowgem-indexing
#cd snowgem-indexing
#chmod +x zcutil/build.sh depends/config.guess depends/config.sub autogen.sh share/genbuild.sh src/leveldb/build_detect_platform
#./zcutil/fetch-params.sh
#./zcutil/build.sh --disable-rust

# install npm and use node v4
cd ..
sudo apt-get -y install npm
sudo npm install -g n
sudo n 4

# install ZeroMQ libraries
sudo apt-get -y install libzmq3-dev

# install snowgem version of bitcore
npm install https://github.com/LEAD-Anoy74/bitcore-node-zeroclassic

# create bitcore node
./node_modules/bitcore-node-zeroclassic/bin/bitcore-node create zeroclassic-explorer
cd zeroclassic-explorer

# install insight api/ui
../node_modules/bitcore-node-zeroclassic/bin/bitcore-node install https://github.com/LEAD-Anoy74/insight-api-zeroclassic https://github.com/LEAD-Anoy74/insight-ui-zeroclassic

# create bitcore config file for bitcore
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-zeroclassic",
    "insight-ui-zeroclassic",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "./data",
        "exec": "~/zeroclassic/zerod"
      }
    },
     "insight-ui-zeroclassic": {
      "apiPrefix": "api"
     },
    "insight-api-zeroclassic": {
      "routePrefix": "api"
    }
  }
}


EOF

# create snowgem.conf
cat << EOF > data/zero.conf
server=1
#whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:8332
zmqpubhashblock=tcp://127.0.0.1:8332
rpcallowip=127.0.0.1
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
showmetrics=0
maxconnections=1000

EOF

cd zeroclassic-explorer

echo "Start the block explorer, open in your browser http://server_ip:3001"
echo "./node_modules/bitcore-node-zeroclassic/bin/bitcore-node start"
