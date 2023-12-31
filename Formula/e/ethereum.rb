class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "ff226be11ade51a902a542b87c4464cdaa96b1d8fc46508f0a4ac173199c0542"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7f32994f5b05c2644c0a136298361f2dc63efb811cc24db1fc9dcaed66dce1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05eb75e476db84d899bfecd84333f434da8c07c80c56d63902e203c7cf42c8a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8916887c236a1d983194b8ed9232cb6efb244bb29ed840020671385026d3993c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3947fda64f1d9f7471c99c6837fd3afd1ac0640e811dc7f407696fd587836e02"
    sha256 cellar: :any_skip_relocation, ventura:        "77a26477d39ac62b7453d982e60282f1501c3df437c74d59c31d461babb6417d"
    sha256 cellar: :any_skip_relocation, monterey:       "4464528dd4f27a859ce1fbbd5eb17252276f561cd57feb3d974bbd3e360a39ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7da8a00d9a5759dc5ac0c532db0d8172bc6b88a1985bb3a81e87685e0285d5"
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
