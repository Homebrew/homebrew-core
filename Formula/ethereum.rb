class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.24.tar.gz"
  sha256 "3b6f08b2622560a7bd9e5ecbe276128fd9774c09f590ff9e23e4b24db37b1d62"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fb411f64c466f474d5c814dfd357f52ec44fdc2d4b99b3b9649e03e5c4f6dcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0dca95c73f3bd3edcc03c7ac80b6e41e014ff58dfd1be85d8a8fe83ebaad3c8"
    sha256 cellar: :any_skip_relocation, monterey:       "17391930674a79efb9b12e8cbbe32ad582121ba8d9677bba09476cc29900a194"
    sha256 cellar: :any_skip_relocation, big_sur:        "4681fc6db9045eb6158c66035e665ddad08b5e9b436c92b13eb5c3296105cae1"
    sha256 cellar: :any_skip_relocation, catalina:       "4aaa4219f9aafcdb6a44da51218f5b598f680ad5476f31554740274d65e2ab32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac9135ec860daf1ea75bd26ea570f1582fffb48a35e60e68df5f3ed1fd793c1"
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
