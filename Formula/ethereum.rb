class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.19.tar.gz"
  sha256 "4aefb4a26d2146c315955f714ed0d14bb0358c95ff6bad99845678263555c7ee"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92220d0cd9e7e6c4c0bcca09db7248c4fc8e9e0a1ea6490c9c37e3079ea72955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a86716cc5589bbb46f344a59ab716b2b1f25b210739c6fb25061ceb2563c4b29"
    sha256 cellar: :any_skip_relocation, monterey:       "d3847fda48c657b7a885285e0eff8c6cd57e74e200e9df7bb5c1f2b352745d56"
    sha256 cellar: :any_skip_relocation, big_sur:        "22e2fc3af63eca723cd24883348b1e84ecb6f2ca74d9a89b9bde387d085e7a7f"
    sha256 cellar: :any_skip_relocation, catalina:       "2554df34c329d8b87e9fd50c96086667b00fb2a10081729d0c429d4b567a031b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f044a6c0646a350f20cc7d2700b37030f0864118457bd81cb8a2d1d6baa55e"
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
