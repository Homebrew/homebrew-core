class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.12.0.tar.gz"
  sha256 "dcd73f341d89f6a195bcdd115066bc7b0ea2ca9983be351ea06a3d41e621f678"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b2f6488cffe7b7cbb75e846efbf6f755e0033c1bc62ab2c2b257bac1df4a1b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32efd24eecbe06732ec77cf8bba83aa16a17e41586285a1e9d841aba5a6c91f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6af2e1912b164dd8038d5856cf256837575370252d0272bf0f9e3cb4c6294dc"
    sha256 cellar: :any_skip_relocation, ventura:        "106c60b66c726072c145de268b96ae23927376cd98845f4dbee61340f020988b"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5aa36411e3f4748bf942c8258a9ed042dd461764628509d16d19b682693ac8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b69331ab632e9643da9ad0c87073585f419191f8f6d89494ae2ee8a1b71b1133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12baec581fe99ef73cb519262a9bda4b73e6dfb2adef4d119abe26fd969e1e58"
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
