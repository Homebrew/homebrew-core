class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.13.3.tar.gz"
  sha256 "c5bfe22c29e4eb1b61d620a02455eee76f3347d2ff932c74c1cc479bd3dde62f"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "653a4673caafb268cde7b923493a770129ea1efae90aa27b22038fda637cb4ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5b6edf3472d6390d2cea60df38fa9f14c1a1c630e39962387c260c07aed44c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e24c6415120b4bba86b0761bfc1d9ca47a345cce1cb5696d4af49215ad20d23"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3b198830d8052866f668f7cbd7e61fe9f1c4554ca0964b41e12e94777f27284"
    sha256 cellar: :any_skip_relocation, ventura:        "d066ced600e427200c839a95c49943583a23b9be4fade34cc2442932a88a60ac"
    sha256 cellar: :any_skip_relocation, monterey:       "9adf503f7be84eb5234df43849f3227b3996e9da992c688a7a76f7b94d205fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d974ea816fc75b2fa9568244244584f25efaeabd9053b6ef54089e4689a8f44d"
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
