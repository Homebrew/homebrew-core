class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.13.1.tar.gz"
  sha256 "7f215fd8c5a2dc6f474339d9091427554572faf1eda26393066e8502db74f6d9"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b371b2023dc0f2b39815c078cc68192035d84c31173868268719c800e673c40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0849de9a78cba0c40fdb7b42058d6a1b8116a67a9aca51143cb561f2ece7a360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "173a181b39b5fe6df402682a45aa623eed380eab185f97d3a9bf055463ced90c"
    sha256 cellar: :any_skip_relocation, ventura:        "1be5e0ffe629a457bf86437aa8de7776f90007dfe825d1cd90fc07fd3e10205d"
    sha256 cellar: :any_skip_relocation, monterey:       "9c16694a235c9e1c4fa104207bc7c2aaed42bfb7452a8946d140afd969e9dfa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "335a48b26ba00acccbd57faf1467161222691434feb43f2618148a9c9a233de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0ebe61fe8c99df77c1e9d8ca3a5d199bdefb41996692d3031547543585b356"
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
    assert_predicate testpath/"testchain/geth/chaindata/000004.log", :exist?
    assert_predicate testpath/"testchain/geth/lightchaindata/000002.log", :exist?
  end
end
