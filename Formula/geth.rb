class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.1.tar.gz"
  sha256 "be8bb83619f83a2e3acadbc82d2ae8064f8b0dbce17d61de72fdbf0a03480e75"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7049d0a15f8a861cf0ed1b4987ab75c361e7c0296021ce4ba92ecdfef2fb633c" => :high_sierra
    sha256 "ce1883e2b8c2816f665bdaaaf78e618bf8c4537dc0e8e7760f7e1255c8b8b000" => :sierra
    sha256 "7ea7b689cfc1d89366c353457f2abf7b794447f7e22c17f5589b6326e8f505a0" => :el_capitan
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
