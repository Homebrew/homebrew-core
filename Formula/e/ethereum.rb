class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "5819ef3768229913dc26226af09dc4521ce30d337ec8b436273defd6e5c1354d"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51d83a41dbce99fc5af22f9af9add53c8db17d0ade1e7e7ec27fe7cca6153755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd9ea239409fc289e5c11e6e3c65813a0a7eae56073acd64d9b606c3e1c2a876"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5b2a920f00d0f2afb0275546294047d548b0875141fedc02923948a89b422f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9283f569f8c19dcf0afbc34a2054f7e9fce036b1712f637a009a7ab94ce0f2d"
    sha256 cellar: :any_skip_relocation, ventura:       "eea5ee9f9dc9b76febf4d40c124823bf864fde2be19e138040821eb99d4bbbb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7be5bb99bf32fa47b483de3da2b1e268ce72b0f9112debcda9ff6cf9bbde3bc"
  end

  # Use "go" again when https://github.com/ethereum/go-ethereum/issues/31072 is fixed and released
  depends_on "go@1.23" => :build

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
    (testpath/"genesis.json").write <<~JSON
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
    JSON

    system bin/"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_path_exists testpath/"testchain/geth/chaindata/000002.log"
    assert_path_exists testpath/"testchain/geth/nodekey"
    assert_path_exists testpath/"testchain/geth/LOCK"
  end
end
