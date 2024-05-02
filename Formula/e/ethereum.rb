class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "25ce1d8d134931c6e9664f3cda8aacecf6667c0e4207884137c752a97a14abba"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4602a5863be1745ad34f368537f1097d209b2cabc76a3f89bcd579e7131f84d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc1b588fbe8494106acfc2287ad9babf18ba4c26eeb2ef70f895f9042c89fed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "343d5ef94776879f433c0e801a31fe83b5c991130dd235e172a1ae6cb3a73bd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9567ddc22bdeaf73996d5f165fa1ed99cbf7985ed4c44f6ccc5e7534929bca81"
    sha256 cellar: :any_skip_relocation, ventura:        "51dc07bc18951829aa1eb83ff96b9a93384487abd750899f0c11ad535c2e4463"
    sha256 cellar: :any_skip_relocation, monterey:       "4a962a8a55bafe50fb704593f503267f8275dd2c6788bfad2fb37c0942a6dbef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d69bd6b920cfc9bca3e5ee4bbd7286e7ee6834f526e41e084f4d3c129823b59"
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
