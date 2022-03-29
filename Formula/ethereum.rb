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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29a5c303850b1451bed5844da4a2dfd346c2dad02c747831e75d2646d726533a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0a2a06fe90df6856186efb2d8ed61d28265a12406b58b279eb9ea99f192b36d"
    sha256 cellar: :any_skip_relocation, monterey:       "fd5cb0f7338c0600357c3973e7092f3835128eb0e7c9ccb6df72986390438097"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae23b1d1f9189f27d8ac3d4593e7e9c9cfe5a434bc2714611f570d9ee02d8fd1"
    sha256 cellar: :any_skip_relocation, catalina:       "e9a8ad3749da4d0138feb09ddaed90e16a443a85c5727d7b815c093cb6a2b36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5595514c919ca2cbe90e380f05e02b66ad83f805080132b100eb692e737682e"
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
