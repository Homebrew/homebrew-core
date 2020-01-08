class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.9.tar.gz"
  sha256 "52fd34920841c9915d67f28c416ce7e98b654c116b03edee94f6ef06e5a8cf92"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab1b11ce6e0223524972556ba611ea9627db20774eb8cc277f08800754fcb356" => :mojave
    sha256 "36207864c75779d13823f9dabf7ea93e165957f58b1b7bcb29763026fd9f590b" => :high_sierra
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
