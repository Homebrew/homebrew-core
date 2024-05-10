class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "6afd520b5922218ff964f840931191ffc122afeb25258c199304cb2aa305c7ec"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "695f5696856aba6ce99f77ece37ad26570c10ce7b00eed64487b7d8b811fc650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9149d5039466b9146837dbfff943ce7f68680e6b569bcf55cdd0d8d4ecaf25d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50a6a38d1d8703f3903b5115364e06691cfc1eb6db55522900ff884968b723d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a381efa65ab9c68904150d040aa666cfedf538897a69b9d1a74ccba4f1ca10ae"
    sha256 cellar: :any_skip_relocation, ventura:        "1da7e832ba0a6ec1dd60dbbe5a455bb481e08b590bc67cf0a947b54cdbb378aa"
    sha256 cellar: :any_skip_relocation, monterey:       "c4d1907b150a0f047fdd68598137703629dd579f2e1e668370b2dd714296c14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f8e1c29215161dd7bcbbc8e1283fdafacf0492de2ee96dad8182b0cc999ebf"
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
