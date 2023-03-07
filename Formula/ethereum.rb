class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.11.3.tar.gz"
  sha256 "46b08903c26ce14f04a4aca24b154ef2e7f5dcf20feaf257cc8a8653dc1080dd"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8c1408c55b47a878a959f5eead1554137701ab4f2e0e1a5139bded87ec751a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93636a38af68603b71f9476d03cc1c163e88c29098df7d2e30769c4bdc5c416d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5f12df1c492333f0681a11b9da0779d2c46f5f4867475b418db59e5c36acd73"
    sha256 cellar: :any_skip_relocation, ventura:        "baf59f4181f924f6f44e62f553c0ddf9e5784da349c4a7576a412ed8bdae9ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "90da956bdb2af6eacb4b378db3ff3965bd4557599054c197563d6ce77e3f586e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5afa081c951a906fce5318c7e0acb0c1a5c60afc94f2c206110f62d3357ea1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b7788dd7a8c13ebdfb8d7c49ab411dc134391363a39b15057ad0a57c33d22b"
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
