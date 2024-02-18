class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.13.12.tar.gz"
  sha256 "67e233ab4be1dc0725d24e085131bc7aaacf33e6c0aa96798adc9a641f6e8b7c"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "382c79ccf47a06a618fe6044da1a654d15241e350ee7f0069284074dd9e325a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8684bcd32c19380a31a473c2b57212d96418f54857c928b77165e9aa46b5b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fd76e1521a988ec84e609d59d2b0cc68502e4d48bba0282e0be57419cab10de"
    sha256 cellar: :any_skip_relocation, sonoma:         "58273f8703ba01d1c6ea03bbecf1592e1f19fe58d2e2cabbaad9375d46719830"
    sha256 cellar: :any_skip_relocation, ventura:        "33f34363f76bcbc707da9cfb9c7a95eec075f358ad764d2d7301e310d7680137"
    sha256 cellar: :any_skip_relocation, monterey:       "a23b57fcc7e4bbb00d6fac1767056c950a9df4172dc96b2d204b9eb46dff3c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a91886d5052211864cec734bbbf95d65c203501c2e4c992e9ad6ee3a15d98363"
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
