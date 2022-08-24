class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.23.tar.gz"
  sha256 "44d89b50a9cce9198aee8b2f10692949ef9b477b315f18bbd7e89b084416f4de"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfff51d702ab9361c84b9519da03d6848892b5a52fbc6f65f62f735e4e3ec417"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdb80a14694846ed5bb86a8ca89b3b9acd8d35cc0b90f3f60260b9c00c698e84"
    sha256 cellar: :any_skip_relocation, monterey:       "5abc4ba4734ed9e40bf9bf504ce5a30927634e2333812f824dbe5189f5b1bc73"
    sha256 cellar: :any_skip_relocation, big_sur:        "7754fc1aeb60f182c76f67c6b74a9c00aeebc82b58a7ee695328eaf968f8d13d"
    sha256 cellar: :any_skip_relocation, catalina:       "dcec7dea1571aefb2fdc0fb2918b10dccd23ada117a6855468729417060c09a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef43fb5522246daaac7569d43378269ecace1eec3e7ca94dd2479f42bd7f362"
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
