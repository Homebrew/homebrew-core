class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.19.tar.gz"
  sha256 "64a2954a98ad19e1d2653e61abddda06e86e3fa93dd821c3a4f2d1cc7350dcfc"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b82b7c4cd9d7af1e880a38c04e9884078234fe53b1ecef9490246c1f8a21d36" => :mojave
    sha256 "ca27f23d66d86920ffc5d450c2c69342a8b35d8ec3db76e09912dff2ecdb75d0" => :high_sierra
    sha256 "f4f93bcf9c03dc4e7b0ab9abc1b82798aa8787b54be63b35a2c328b77f8bbdf9" => :sierra
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
