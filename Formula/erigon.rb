class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "c152568032cdd6b8a4401c11f5bba57845815c2bb0a43f396b8729c2a2f7f017"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d42726ddc83915e97367ca0f9e874963e1a6ed59a3816550fab93dc83f88b2d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d8551089edd2cabbe70b8aa8141072151e71fe30094de20022f77846314f2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d865132c211785f6379ba4f11e50d87ee715327956e6e12529376c315113f3ad"
    sha256 cellar: :any_skip_relocation, ventura:        "18ac2edb5b2945b5f0952dafb867f979751603b9929e0b7ac2575ef225db0cde"
    sha256 cellar: :any_skip_relocation, monterey:       "39ee99d8048df4b293cd97aae13a3774c3bce16f938b0e37c07c748064eb0cdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac95b4d73b8031fac02ea52d2a74b37617a89d20f30e2cc0561ce1c44cdc55c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e658376e3869c4759ef17877e40dcd9cc8b36351ea1b0455e182a3fcae81cae1"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

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
