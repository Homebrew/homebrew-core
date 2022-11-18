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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e13bf6dadead8df0261a5439dff7f9e251e5eb107f6c35056966b441ded2cdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3cf1e67e28267a07d6ba402a005bf06af6b35b10235a8cb114f42a50b68ae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "393adc7514488a06af9c0e4c16e6f5272fccc724dac62f9d55cd873ef89c1866"
    sha256 cellar: :any_skip_relocation, ventura:        "72117e6835adfd03a9323e813f9bcc170728aa20d74383b7a0b55591bafeab6a"
    sha256 cellar: :any_skip_relocation, monterey:       "6239b5839ed270783437e0bfe50e0bd9b81c029645cc467c5328b322bbaaca38"
    sha256 cellar: :any_skip_relocation, big_sur:        "179133d5436cf346fab4620a1c2564cd47eadc877641de0af203dd6ec400bbe7"
    sha256 cellar: :any_skip_relocation, catalina:       "5d6308ef0cd4213b1755b5532b97800a37ead217792ca0cb8ea38a4009378c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5034f052b701d4f1224a5d60be71a23c508606b876f523cea9a18481a0285852"
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
