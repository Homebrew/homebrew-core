class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.7.1.tar.gz"
  sha256 "403c1e701acad24e4132db55e8796bbb03ca2135788943869abf5f7bc8919dbc"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "798f4aeb018d24a6eb3e3e84b6aa3ea816d72f5a0fda97b025849138cfb19408" => :high_sierra
    sha256 "7471c13ca4a5df636b74bef9608a104e8358e44aa0ca934ea2e77b0108b2a7a8" => :sierra
    sha256 "dadcadcc18155e407a5f9adb4ea728568bd92f8e30da997e25c9f404d02e14f3" => :el_capitan
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
