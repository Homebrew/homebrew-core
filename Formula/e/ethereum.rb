class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.8.tar.gz"
  sha256 "4a5fc87d9c59ccfc5c762b87e7467c2d2792397acc144e0c02655c4ac206a5c3"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3d91e187a4148d481a5d9deabb4b507b75d553631d27af7a11bd99b14448027"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f8a2dac80416d7f4c2e40246c792e7cea12078fda77d5278c1ac7f23125344d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76977435f02053dbd119ab131b480827ee6b6070cd48649c9be742b3af6eeb4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4233510f145ea3958a705837d37f692aabc0bc9f1626ef5213f1b34e1b869f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "b750478babdf9b400ff6322c5a0af91c873e1a9ff156f055508fc861750f43ed"
    sha256 cellar: :any_skip_relocation, monterey:       "6db9b8c3be89fa43f71c6293573909593515b23b0edf0bbb990d16680aa5adef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ab24967a017b94042a16664efcc883888c6a39e4f2b4b5483c91b458cef2b2f"
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

    system bin/"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?
    assert_predicate testpath/"testchain/geth/lightchaindata/000002.log", :exist?
  end
end
