class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.11.6.tar.gz"
  sha256 "1c34d609bc9d308ce1e0d4fbf5015ae07ef5ffa5144594824f85e39a54fd2b3f"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "743591bb9c0abf3ec68f541570e91f57c70aece11fa4f7de7e1dd5b0d8891b9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1f4573d5d0650ac5b2a7923751f5344dad2d2c511f02521a13456d87fafc6cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ae235b77c038de008e2e93513971df72104066e78edb71d719a330d70a8376a"
    sha256 cellar: :any_skip_relocation, ventura:        "d606bc228d22726e63046634af3a2d36adabe1222c23aa3ed151dbc011789db3"
    sha256 cellar: :any_skip_relocation, monterey:       "1b2959a0f1fb375f767156ae7a0cd1957fe419b85597a6857e5381008fd7469c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4c470971feb0bb1568fba2ebaa9be5e0ae8302707f61939ddfbca2f309de841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7507d6b6255e8c74c8d12e1070f635856c65196b6e62a24bab1f9c76aaa28d9"
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
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
