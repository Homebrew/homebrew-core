class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.48.1.tar.gz"
  sha256 "8b6502a394752156d74d334b0c893beb45cea59baad8113ed9a2106de13582cc"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af177de64b630ec20db621eb1f1132ac4ad6eca1d0f44dca00cf648c8aa2298d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0122e639d980cf4b2aea8c4a8efab6016774b1f562934a7b2b6915e9ec30375e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c4c97b1ca99226a1f75b64ca8561d33a40832e81fcb19c3fafae8d59354db6f"
    sha256 cellar: :any_skip_relocation, ventura:        "cb6b6894fed8d3af8571959a20d1da965ec9a225dc7174f4255d8e2567972f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe52f7af468baa32a38e2f4964de05f7c877dc6afe56fc5d3117c74712dc6127"
    sha256 cellar: :any_skip_relocation, big_sur:        "97b2e849f77626ee7fb0a8cef5a03ffa7aeb866d8d8e3349e1dd714ab8c91b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf702c28fc1138ee1399f7e3f57346e1728a3979957364a4ed7091b4be11988"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build

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
    assert_predicate testpath/"erigon.log", :exist?
  end
end
