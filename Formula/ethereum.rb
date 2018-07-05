class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.12.tar.gz"
  sha256 "53cfd6ff2f82f7a42fa5175e2a795aada4425a22353e5d46008cd566bfb5e239"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24c8e4ea6cfaa9ed1338545a838528d2e3d2e5e04de860cae6924115227ec773" => :high_sierra
    sha256 "7df755149e38bbe1367973dfb7352c6ac9c2dc8ff3ff217bf24e1affded8240e" => :sierra
    sha256 "923735c7ef1debbbcaf95263314d2af54dd562009f748026b2de12322afc04e4" => :el_capitan
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
