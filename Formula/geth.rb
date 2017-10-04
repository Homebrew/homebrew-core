class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.7.1.tar.gz"
  sha256 "403c1e701acad24e4132db55e8796bbb03ca2135788943869abf5f7bc8919dbc"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "684e166bf299f5310e92aad08adf24d1c2e79bfd2b53a6708c5e952d7b825057" => :high_sierra
    sha256 "f5bf22916a659231a2b1b9948051c4b167744e8e21fc865dacd55888f5c95a6e" => :sierra
    sha256 "05ddf156a58fab5dba3a2522e3090a38eefecb06a503b1dd3672536bb74097b4" => :el_capitan
  end

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
