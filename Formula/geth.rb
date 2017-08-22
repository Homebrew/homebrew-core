class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.6.7.tar.gz"
  sha256 "3e2a75b55ee8f04f238682164a7a255cae7a1f939893c5c97c2adcf48d7d4d49"
  head "https://github.com/ethereum/go-ethereum.git"

  depends_on "go" => :build

  def install
    system "make", "geth"
    bin.install "build/bin/geth"
  end

  test do
    (testpath/"genesis.json").write <<-EOS.undent
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
