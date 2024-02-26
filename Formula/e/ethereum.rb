class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.13.13.tar.gz"
  sha256 "4b830e699a97809fa89457c7a8fe18bbbea35cc1092fa91dfc2c7d25798ca3ed"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7aa6eebfcb82bbada9188e54a5ef8bfe57d8c771a15cede7d0d80b8ebffe1b34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad7c9fadb3628c17164ddf34d69e790724a0ecf6ad53a3b3783f4680853793ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0af3fd00c7f51f9431879a19036cd9820003b7a09b16f2ad6ef915fa7f33ca2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2924eb5136bc5b65f0ab70387f9ba899eead706bc1d84f6fdd23e33a211a014"
    sha256 cellar: :any_skip_relocation, ventura:        "03fde84b123b47731cf1be6d28db82e745ab0a4262e86d45eaf6042ee9bbbc78"
    sha256 cellar: :any_skip_relocation, monterey:       "fdcb73abd4587db7fefdb269e99ad01c37c91ec38ce0501a683b412c06813bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b6288d88aec9dadf80636aa8f484bfc33811bdd0ea086aedfbdc6dbe674c3c"
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
