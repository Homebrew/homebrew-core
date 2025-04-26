class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.15.10.tar.gz"
  sha256 "93971abb8605d549094d7fd56ee3e9250bc7d4b75a40847ff934ed3c217ed515"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acd44cbdf3213b634525538f18139f474008aeca712bda7b7c8a729a5862da3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0493ee7cc71d91c782e25dcdcbc1a9daa34a41f539d00a743e4f8d5c6d6f19d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "548e301e2784431be78c38bd16731d10575b5f64a46edeaa3cb4e3e219eb99d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb2665fed871b05bf4e003e99d825e4e802e0209bbed1feda06fadf7f22301bf"
    sha256 cellar: :any_skip_relocation, ventura:       "b1ba6330354cfca7a9f28c7e6cd2a52ebba0c1b99cc3f6c710ab59348b84517a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ba18df1434816cbe70f321b77e9251f37979762640ca143148c15080d7059d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "200cb6f91cc97c1e1ba1c0ff97f3845398bcc9b3c9e060244ba99f24cfac97e6"
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
