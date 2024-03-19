class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.13.14.tar.gz"
  sha256 "629723fa82c629581ccada149c05d2fdbcbba04ad783042d4cabe59434c4759d"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b7f7689714407b03a9aaa1224195db3d56c7364ab0e633557d62d5171fb3b29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "666056493bf57705c5d97cd8495af88a6643f5870b861bee63c5eab658e728cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d14b0b273e0eb052c32ea4aadc14129d409142bb77de3e5bbbe368fb0f8e3bdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1ba561ebc4860e4adc06ab7336d9f046e2e5a7d70fffb0f41c089284de150fa"
    sha256 cellar: :any_skip_relocation, ventura:        "253635e0c2df26290b7a165bf7f56785268f6c26512c7ee285547b96ad638114"
    sha256 cellar: :any_skip_relocation, monterey:       "9aec277d05293eb6353fd9c10e0d8635f8ef6fc5270ed9c3cc5083fc0587f9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f2ab0e3e4e3de482e63e420fa7d78d252e6c70fddd8becba456e868961ee6e0"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
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
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?
    assert_predicate testpath/"testchain/geth/lightchaindata/000002.log", :exist?
  end
end
