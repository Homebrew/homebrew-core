class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.8.tar.gz"
  sha256 "3072ff8090c948648d365f6f2c0144e10f2e74be1fee85046d952d089c5765cb"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82c1c98cb185a5c9b4e52ac396002e06dc12e9aef8a06226cc573ebc70bc3765" => :high_sierra
    sha256 "1cc7fad73708cd295bb13318934bd33096a44bac6f5e2fe08252378b108b3577" => :sierra
    sha256 "be2c06c7e2ced6d7037a0757feab7d4645ca087f00221d4447b6343ca74dab8b" => :el_capitan
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
