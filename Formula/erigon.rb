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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2142ce508775ad2417f4c870c2fcdc9a364c5c6f2b299f99b7fde5bda9a88f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31f533b39a6bc8925cb8d2339adea36a07e32b71e0219d6477cb4bf56cb87d10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "104c409c36f9bf0beeb5409acde0e03427330ab10fc66f64c44f918cfa633882"
    sha256 cellar: :any_skip_relocation, ventura:        "be7d01096f6aae0b2b74790efbf42266f6dedffe7dba0bd1991cb5cf7f1a0829"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ca85ff82fd8f4c3f62ec644b9ef3c0fddb68d8ac619f35c61fa1a8e9220b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0d007a283be8ab6ee68c05303ca59b86e638089d8ef13be9f9cfae47dfcc50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6417ba04d4f97adfdf8af01cc0159d6695b11a7cb46d21bbd87e2a6a44122130"
  end

  depends_on "gcc" => :build
  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/ledgerwatch/erigon/pull/6848
  # Remove on next release.
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
