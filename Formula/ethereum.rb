class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.12.tar.gz"
  sha256 "d37c55db77be5bad2a4a844cf0a3c0e01bd9daa898eac23b4cfbd9a99dca8c06"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aceb0486490d22a0a53ba7459353c7d536bdb7f58040292ba8b74b5bf5d5e714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30fdb425ca971b75d120a9c624bbc9acfd439b95dc8808212fdc489f57ea9ab8"
    sha256 cellar: :any_skip_relocation, monterey:       "7adbe849b319431952cd978ee21afe3a036d5f9c02be80d8a3be313cba3f3260"
    sha256 cellar: :any_skip_relocation, big_sur:        "2897bbbe18a96bbb206c09d270059083201c2e71f4250e67f1446fb973f1d19c"
    sha256 cellar: :any_skip_relocation, catalina:       "d6f9000ee307c0d8860233f408a3c51957fd647e62e56022aafe6036e8b13c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ba971d8d5e18044f715d9d302ca7d145782e013c4b348de9827577d71c2804"
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
