class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "3495357190899816fdee35b48777fe8f6155d4f69137091460db973c58976b3b"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db55bbda691fbd5979e33e0e9e8edc5ccfd0058a4e6b08182415cd757da59383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c119645ef5df7199a660be6a28297117e43936a41de8870fa6fc4b2020dfff82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e55414cdde0676527ae427d03ffa661e75641a6e34202eaf0bd8fbb0d5deed88"
    sha256 cellar: :any_skip_relocation, ventura:        "d245827e37ef382d55d332edb63e2a1de397e4ccbc5fa1e0b9d959e6d8ffe727"
    sha256 cellar: :any_skip_relocation, monterey:       "51fb4d079fca1a49cf28a1ee202f4a871b28fd2c6aafef7fc3a44a4c0fd38d98"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7827fb4988ded74c92872ef85480aff17d9857ed806aa44fc9e28c1d7c92bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de08be3ee3f795b5e6a27e698daf2d9280530d3ec8924834f82d26424c43fdd0"
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
