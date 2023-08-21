class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.12.2.tar.gz"
  sha256 "5301e2b830dc78a357778e22876b746dd41bacdc4748798e2560ed7e44bd121b"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6344344eee5a0b50aa6df90562f4b9911c036c297a1682b56a489551e7da44c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089d68f49b523a08d487b819dca23cb6a67a32ea08045567425aefcc30b999ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b345b22d031a2002f13f4ccbbee87ad1e14ae965038f9b3d97f2634c0f58f8d5"
    sha256 cellar: :any_skip_relocation, ventura:        "217339abe195af1f642e07b1bd909b4ff7163598fe703a418559eaaa5b9a6f50"
    sha256 cellar: :any_skip_relocation, monterey:       "2d24fd98692ac11b1a35ab50be9a573b913e08ad59c6eaded141d970c3019aa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e392ae729929b56679a0d101fc37d4d582f456f6c4491b71772007b06bc8e57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a1ac1425a7fc127c94f8dc6329ac2083b2c9ebfef833f7352458360b7625bd"
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
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?,
                     "Failed to create log file"
  end
end
