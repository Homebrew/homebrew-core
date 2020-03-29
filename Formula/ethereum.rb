class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.12.tar.gz"
  sha256 "b232e28420f93d46c1330a5f06fa238bb4930a81615f96c987419e3ccc610eaf"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34785bfb5c6d5e7300b5f9bdee6df9db76bf963d2f984d3277bc9a34330cd478" => :catalina
    sha256 "24c12439bfde4e94066e2f42a4f8bed66642ea67aa79b588fefa676b7dc85d42" => :mojave
    sha256 "70aa292002fe88ed73f4baf940594661b6bf7babb50d0a2ed373f50b416a558a" => :high_sierra
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
