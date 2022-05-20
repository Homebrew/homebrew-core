class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.17.tar.gz"
  sha256 "00db123e1b23d3d904bd8a6bd4de8f3330d14db1622e8f22bf1653c94f03e09c"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f3ee53cb2809f026496cb1dbabb66b27555ce691608166cbdcdcdd15489a6a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcb07942fddad27093e4b987a30b5b56dc8c5b9421191afb14ea66254d8617db"
    sha256 cellar: :any_skip_relocation, monterey:       "1645e38df863b085c94e632b1abb53f7b2267199db1c9e700773593650650604"
    sha256 cellar: :any_skip_relocation, big_sur:        "13a96148a182e46c24082a1c6642f0d232bc5ea570fbd6bbff8ce5752812beae"
    sha256 cellar: :any_skip_relocation, catalina:       "64b0aa19ed69711f55f819ee135caae41515e32abc3f36aed5e954654d27f2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea127fb7cdd35e4d132733832eda9a30ae8e25ad64e5c3e43b41fd5a6f7d743"
  end

  depends_on "go" => :build

  def install
    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

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
