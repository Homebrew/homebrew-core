class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.1.tar.gz"
  sha256 "485ff7b9e5a34457ab424d7e2cb8d377dc571e8daf666e065a0a327b9e413cab"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f57ac503a784028d5252d08c34f770bb42e438a7a9ab5dd465ccd6ee9a38c86e"
    sha256 cellar: :any_skip_relocation, big_sur:       "acab9d99b760645bda2bc942afc1d854f82208689e7d85c0af49b51112318bd4"
    sha256 cellar: :any_skip_relocation, catalina:      "bfd3fd35787a554da49bad238e9d2477eb33733593c0dcab1a0f7b0d4b73f34d"
    sha256 cellar: :any_skip_relocation, mojave:        "4d0d76de9f326cbe149f2a7286f831c376c24c860ceb482ff24abdb69fdc50b0"
  end

  depends_on "go" => :build

  def install
    on_linux do
      # See https://github.com/golang/go/issues/26487
      ENV.O0
    end
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
