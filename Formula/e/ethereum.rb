class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.15.5.tar.gz"
  sha256 "28bf39f2ef52d4b8a3750307a9bc7fb92db30983a7cb50cf0db4b38c630fe790"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49f30788d58a99a5b041f05ade61ea072e2d2cae8a67bc5d35d5c86c9ebf64a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73a3ab586343d0c3295d55fde5dde0f78830f0fd7bb393a3f121209fc38590fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe64c15ef20618a14d25fc92f9d18482dd4e36609cf296c196eacecbceae83b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a34e74be3acac25d36397811ffa9ddd35fc14a213535b617663097a38a2d83d6"
    sha256 cellar: :any_skip_relocation, ventura:       "10569be6f6dc78f33541eedfaab4c9da1406eca06aed92322c661ac8998a38a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6532455e21ac68057187e21be89b30919dfb5a15b7c45dc25c64bc63f8f6ff"
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
