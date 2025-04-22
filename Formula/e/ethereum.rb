class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.15.9.tar.gz"
  sha256 "55f2fc3fbb6a22473fb9c6722fde349b5c7e4861786b48d3f9076d857ccc7bc2"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4538c3c4c017efb98c70c48494c1d80acb60a982c80e962600ec2bae6cb9e15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce8110c7707f3715bcc3b3fef0448fe5c0235a3642ce2132d56d2b6cd36c9a54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd0dc82f8b9836623928a68deffece82482b170f86850dd038b75bb7d652875e"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ecba8bbdb5aeb3c56992626495e8f221d0898c0d6b5fc152948689eab4349c"
    sha256 cellar: :any_skip_relocation, ventura:       "1c1497106d66c919f24d37d77c20c94d58df9ca9fbc1b3d915fe998d58409b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b5dd5277a4c0d3cf0cd06d56c632842ec914384d6c2a5c2633b162f1c9e8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3d5627bcee4e42ad21879b26cb244d056230f39d1f2964f4fc9aa2871eeee8a"
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
