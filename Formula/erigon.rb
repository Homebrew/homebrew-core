class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.45.2.tar.gz"
  sha256 "4ad08670b7fc1ec5cf1365ab50570ed5efe3206271fdf85e475948a4b349b141"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a70d7fcfccdfb99d6d2240e45e4cbfe4f37139cbc1045da5e9069b18b19a7764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c2920f1c3c85e53dabeb490f5276f57b547269c57f670b1a993ce4ff0c1d7f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03f1f2882e9d72991f2750ae9d037e0cac47d27d0591a95ca672dc9c5b6bec1c"
    sha256 cellar: :any_skip_relocation, ventura:        "7db2f8c91b205c332f9b467f8388dd4eff9477de519340d2a59ab0cd7e2f21d8"
    sha256 cellar: :any_skip_relocation, monterey:       "8130b442ee31bce1ee88687b439c6dcd8c5b7b07128e14f4c9f49fa1f41b8e06"
    sha256 cellar: :any_skip_relocation, big_sur:        "c379ad4e020f4254fd259a821ae7a2132360e190d7f783b3e001fbc271584358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1340e133723d77983135c1dc45d6b2b91a8d02319dc9877af005db18e29d191f"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
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
    assert_predicate testpath/"erigon.log", :exist?
  end
end
