class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.11.tar.gz"
  sha256 "5e4cda78d8e91d7787283d447243011f7b73612a5f84b7e67ac6bf237835151a"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "354a3907e523a22d7285ccf0c8d7b3f51133044298f354f917f7b03e9059a1f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7d8cd760c8baed4a0f69d614bacf969f6ea003d564f1b7ccb41609d4e17ef95"
    sha256 cellar: :any_skip_relocation, catalina:      "818f8594b2859f7f4e95a2ec0b61c2513ead6c2f6af4c8664c47c2e4bb7ab0eb"
    sha256 cellar: :any_skip_relocation, mojave:        "d245e8f9b87afbcd79caf1555f215e473e46d5e2b5173c34bafcb16ba9fee291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb95eb842b767ca0233866923929a4a1fd87924ebd46a7cb328a4617675164a"
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
