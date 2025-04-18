#!/bin/bash

# set -ex
# source init_dirs.sh
echo "prepare to create configuration file"
jq -n \
  --arg port "$CBFS_DATANODE_PORT" \
  --arg prof "$CBFS_DATANODE_PROF" \
  --arg localIP "$CBFS_DATANODE_LOCALIP" \
  --arg logLevel "$CBFS_DATANODE_LOG_LEVEL" \
  --arg raftHeartbeat "$CBFS_DATANODE_RAFT_HEARTBEAT_PORT" \
  --arg raftReplica "$CBFS_DATANODE_RAFT_REPLICA_PORT" \
  --arg masterAddr "$CBFS_MASTER_ADDRS" \
  --arg exporterPort "$CBFS_DATANODE_EXPORTER_PORT" \
  --arg consulAddr "$CBFS_CONSUL_ADDR" \
  --arg disks "$CBFS_DATANODE_DISKS" \
  --arg mediaType "$CBFS_MEDIA_TYPE" \
  '{
    "role": "datanode",
    "listen": $port,
    "localIP": $localIP,
    "prof": $prof,
    "logDir": "/cfs/logs",
    "logLevel": $logLevel,
    "raftHeartbeat": $raftHeartbeat,
    "raftReplica": $raftReplica,
    "raftDir": "/cfs/data/datanode/raft",
    "consulAddr": $consulAddr,
    "exporterPort": $exporterPort,
    "masterAddr": $masterAddr,
    "disks": $disks,
    "mediaType": $mediaType
}' | jq '.masterAddr |= split(",")' | jq '.disks |= split(",")' > /cfs/conf/datanode.json

# merge the override config
jq -s ".[0] + .[1].\"$CBFS_DATANODE_LOCALIP\"" /cfs/conf/datanode.json /cfs/conf-override/datanode.json > tmp.json
mv tmp.json /cfs/conf/datanode.json

cat /cfs/conf/datanode.json
echo "configuration finished"


