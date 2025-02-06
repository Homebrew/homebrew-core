class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.13.tar.gz"
  sha256 "55b63fb34ef0bcadd438ec3311f9e4b6e584220d2f4465386afbd377ad5ab1bd"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43afba6101a45044059736cd76bc11d666326503223a7bff84fe7ba925fabd8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d364bd76606338fe7da436194589d4dd4b3d09ff2d97101042199ecf16eb5b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21e0d8d1e4ffb76c4c307fcce091f1a3b7191d28812e5480d22fdf5c9bc74ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a561d401eee9217c6bf7f526f28916cf1ed39c40f965d419bb25bc87acf19272"
    sha256 cellar: :any_skip_relocation, ventura:       "49ff865d1a0856f431a0b23fa3498937d20b29fec9f2d6a4335485b8f579b5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ba0f11fb1c4630003a0c7e4163f0cdc937ce8a138408a08779cbcc2a32a55b"
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
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?
    assert_predicate testpath/"testchain/geth/nodekey", :exist?
    assert_predicate testpath/"testchain/geth/LOCK", :exist?
  end
end
