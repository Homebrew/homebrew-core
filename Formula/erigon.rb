class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "e234f618014076a5b29258a241bd6894973adbfeabeb58fc784fa95f3739ca55"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fbabb7e0c4a1f3577c86aa6a55a876257534a0e1dfd5df70495c6b6cf39c9e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8ea04595e3e881af332a37ef676f3d0755c3ffb6d482ac713fa9c4c98d33d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ef19fff2b687c62775c723ab28ff5cad08b40e1c7f907368d3d001c2ca59cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "49ace37c7c0dc8713b8155926084e93f50cbfb3b8c45c09b44af6bc34851e397"
    sha256 cellar: :any_skip_relocation, monterey:       "eb857f329d0add75ed3bf716f22d469957243bca7e30cb9f1a5022a9f8646dc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3b9c68a06b3207b4a3e4330fc9b9cc24408839f58ddfa3c44bba3d48655831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5072b1c29282ca0645c95aa55f9da89e3a9d3ea61ff63fbe8889b7f9012418f8"
  end

  depends_on "gcc" => :build
  # Build fails with Go 1.20 on arm64 due to https://github.com/prysmaticlabs/gohashtree/issues/6
  depends_on "go@1.19" => :build
  depends_on "make" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

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
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"debug-user.log", :exist?
  end
end
