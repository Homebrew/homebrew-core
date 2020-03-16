class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.12.tar.gz"
  sha256 "b232e28420f93d46c1330a5f06fa238bb4930a81615f96c987419e3ccc610eaf"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24cc97305a757f4ae0f83700a8f4e6927b4971ddbca2ad0d17c143cc6591308f" => :catalina
    sha256 "787cf4aeb26d0e4fddbd74fcc59b440339087d38bc3ce12f77e3c807993da618" => :mojave
    sha256 "03747a1cd78f00aee15c5c8d7d224645d4f95b695ceafbe61a1047f9678bb90a" => :high_sierra
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
