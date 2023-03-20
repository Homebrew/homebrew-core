class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "b75bb7aa82b1eca329adc36800fbfb6277a2a06de7ac59f602f6192034f55cb5"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c83bd51c04011f15497f94eff87606c2eabdf7d61e80f84acc1c398cc829edee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6071f368502ea87a4eb125fb5fa2bc4298ddc12090e92f9875c3d79472c81da6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b292c1f6675ef825e445b4a78117e7748161a904a1a884bb491f75a74e267dc3"
    sha256 cellar: :any_skip_relocation, ventura:        "34b834380d478310c7b93a734dd03dee86466d603bc0e3f3036656706d6790a7"
    sha256 cellar: :any_skip_relocation, monterey:       "ae2e29d3114f4ca28f504164e36a6ed81ab751a5bacc867d3215ce438d99ce3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c80f0183ad8887a9990b2c11b227e38dfe487dfe783b9a9b23d73717cb4f7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806343a0c926896909117ba9f7b261703f282ace7094561d816315673b15228c"
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
