class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.26.tar.gz"
  sha256 "500bb2c2382d1927da1b78226a726437370899ce6f130258d5792fd7c46cc29e"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb70635fb362ec04c694aacf5125b156c61f57fa6f9ccf6adb16c2b5b5cd6e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e5bd90c20df26de1da09649fbdd19136e5bc76f4bca38cfd39cbcc258556e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "057e204d0353319d95e814dc7a1612dd8af2680716c2a9fd24979f20be2b4c63"
    sha256 cellar: :any_skip_relocation, monterey:       "c746f33f583add1ed450bcfaca57813ee3ae53c321673c882d84bd2a841bdc80"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6462305eef149c1d739dcf95f4c3cc5c33864b6e4c59ec3802ef062d6196608"
    sha256 cellar: :any_skip_relocation, catalina:       "9317bdc5547350e9f7b90b5a9d88529d8966e774eb07125d6a1ba348a122a8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84691e5d8f6bdcbf7f674e68f2f361b5b186c6b30fbb608a3fe5cc7fc973363"
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
