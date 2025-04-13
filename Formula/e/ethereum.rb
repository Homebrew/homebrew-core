class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.15.8.tar.gz"
  sha256 "3e05295851a33a293269d7c80e23c6be5c278ff73e3ce510706689acc09fe90f"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba6ec51eb6e67add059f53bab9aec2bc3650f552745262fe17156b9e6493f2e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90678cb00f6d96c15b6875f7afae847a64b376268971a70f1f736fab806300dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f7de957174b3687b6e8bbdd6bd9260b988e9b176f21ce7f2306ed79c7a1d97e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cb47d080df9df8dde94e41ae366e9e76ecc2ab23ac5fcda87d17d1a1eabb7b1"
    sha256 cellar: :any_skip_relocation, ventura:       "5ac5ff00ddd4459feaebcfb0aae311d2d364d5467ba9f534bcfb7e02245a2217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b605994d889de17d8e205a2b069bd20683d86349e20b8558768ad57217a1ec22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce4a2a53898959a3c00b02caffcfc6f0e0cd49a78572301aca72403850ac714b"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
    ENV.O0 if OS.linux?

    system "make", "all"
    bin.install buildpath.glob("build/bin/*")
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
