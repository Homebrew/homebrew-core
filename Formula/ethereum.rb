class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.15.tar.gz"
  sha256 "0c03bdf88fc01053fee8d73e3acc9579354b8c3c2333b544b800040dcd414963"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096369b238b65b02bf9a04560a019be275c205341d6bfb3862e09be944bb45e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08441a2b3955656b3d38a49ad9769c15f84a489635d424021502b1cf178d483d"
    sha256 cellar: :any_skip_relocation, monterey:       "3e60aebfa1605f0e6dcc35c6eafad8e1d3ae8b898def1013db588db12e5d4bee"
    sha256 cellar: :any_skip_relocation, big_sur:        "6205a279365ea9c26af980066493ecf07bd8ff7fe2338b7bc502abb074eb9953"
    sha256 cellar: :any_skip_relocation, catalina:       "9939572ff44086210ef98dd5f6c2d19bef981ec40c4d736219d0f93de02d03a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6556db398bf65650875e7a737bb2b751360d36bb16e6f810a372085fa37546ba"
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
