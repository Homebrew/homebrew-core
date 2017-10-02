class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.7.0.tar.gz"
  sha256 "bc33d6f21d9c354a69b45bd01180c5a6744532e74fe87d69b36782ee112e7059"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "482c28166ec0f0a3c30bf0e4a46c35229f6a5db4332b6f52ae00699756a8c110" => :high_sierra
    sha256 "31dd16120f0f1bac73c78290269dd368c407f832bfbc72f297fd951647793f39" => :sierra
    sha256 "4c7422b68122e556784543239933e9562a0a465aaac2b32ab3da63495aea6a85" => :el_capitan
    sha256 "cd1e48eda14f089b9360d391e24f0224f289f212150ae4e9bc5698bfe01e6a8b" => :yosemite
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
