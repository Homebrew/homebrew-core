class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.2.tar.gz"
  sha256 "9e3b744d347f326b7e21b697379173df102139dc13210b9ef55c1ff9659e8843"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29d88221a6083962a2504be41ce0b3e4f9eb0d78c37cdc7dc5aa3bf4ab35ab14" => :high_sierra
    sha256 "8adede1371187e0c5aeaaf6d2e0ddbc4b985600a04e1455db2a2551d47f15436" => :sierra
    sha256 "48afb6dcba37656b40dab0a6c35dcbe49801fa250bbeadf5844176d2b8f6283b" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
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
