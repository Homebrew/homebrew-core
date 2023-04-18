class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.11.5.tar.gz"
  sha256 "0f0d8598db875a789496d161779f4a11901d816c924762947874e5a3ca0c218d"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0028b0839f9aeb8d64de075b7f0177ae1b167cb3a6932d9cc78f3f93c77d6ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff5617ad780e4397f880249e76ce389b625915f5c49b1a9aa65b4237541b9dbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3039c394beb15fc5224080249f9fa5515c008f4a5c842a83bf829091818ab1bf"
    sha256 cellar: :any_skip_relocation, ventura:        "994659c24ddb7e074e20f824d76f1d1da103d44c2dfad5f00aecd7100a4d6fb5"
    sha256 cellar: :any_skip_relocation, monterey:       "2b572634c5ca691484429b9295915d5f27bbe7a997942ba9307e5bf80e1f6a9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "afe568d954ca8a3a124e8e6e563ca4a20cb2a85b573ecc0b0a89fd78491b8366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee4a80f1d8b16fa27fda103622765797b761e99e7af8b6a038617dd0c6ee8c7"
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
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
