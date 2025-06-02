class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.15.11.tar.gz"
  sha256 "d9f584c7d77e170320c1b374cc4528dc5987f5a88d2ea79f700a254597788e1b"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ac7750eb8346e6c4979b4167abe4b88e4c6615f67784c9594c13ec44dcc421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "332ebe65732fcde8fa528bef05e6bc8603d0c7748bfb1a09c906e59a0d84d4e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d6b751bc5445f3b5f5717a6f9a684c28fa64d1da0ed97b57d6cc8b84fe71029"
    sha256 cellar: :any_skip_relocation, sonoma:        "442c454605620bc2b2b0469618356c247787feb47e534eb59406f7d8e438d186"
    sha256 cellar: :any_skip_relocation, ventura:       "ae80fbe50d9762746ba10b098a6aa844373143b34fd433ed36c906e31800c744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d9bc8814e9b4a56f80993de21355daa836c009470e7b2b136056bdac47328b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b351bcb871830ce22904c2ab1e964d777b01404bfcc25ef3136bf5f6f26dd16e"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
    ENV.O0 if OS.linux?

    system "make", "all"
    bin.install buildpath.glob("build/bin/*")
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
    assert_path_exists testpath/"testchain/geth/chaindata/000002.log"
    assert_path_exists testpath/"testchain/geth/nodekey"
    assert_path_exists testpath/"testchain/geth/LOCK"
  end
end
