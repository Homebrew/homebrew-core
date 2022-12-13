class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "eaed8d4e24d813991a53de0b8e89161ed5090168ddae8487e20be89dd861782d"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c625da298616bd5a7993e1ea7104fd8308089d373d503a0372dc2749b742c7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21da5b03ae59058be8a1bd3750f6a3ab2b6a6b04a891fc267600e33600a24b68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d5508807c013aa60a598b916d46b292ca592cf29daef63fbf1fbac8e6f03551"
    sha256 cellar: :any_skip_relocation, ventura:        "42d8216f8f41644254bec698bbc20168fce3467287c4310717b1992e35d1e09c"
    sha256 cellar: :any_skip_relocation, monterey:       "a9c317c3c2015673c92c95c119134164dcd3b34924f8dff74cabada5cd5adf3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "680b3a7fa4e6ccf78768b48110084afc336b1b7eda584cabad4826190f1bd94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b5f6e701cbe5ab6a8f24197f08a4b5ac901949af1d0eaee6a72de8882efb77"
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
