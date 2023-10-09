class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "5d91fd54952cd8a56d029cea0b784352434f90d698d95160bf46a5d8fcfd7ebe"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c0a4b25de2f1d56e0aa8b0e5a088f48f218ab303d9d7ccdca7b0c1604876ece"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "777d1802065bfdf163b81f4aabe7cf4b670d64903392ecafe76cc5e4466b782f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "869d0149fd0987288e57e2735adb9c376fbcc33522f781a84e4757a516231a26"
    sha256 cellar: :any_skip_relocation, sonoma:         "cafc61245218fcc5bcafd205d22bd7295388a684731366e626331712ec154e7a"
    sha256 cellar: :any_skip_relocation, ventura:        "09a1be765a9f2cb7347e49d4093103555a943b2fe7e324ef272e1637af0b39be"
    sha256 cellar: :any_skip_relocation, monterey:       "153a9d180ca533924860c047e153314cd4accf5d5173afb1d72d70295a2feda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6d4818c2acb0db29e8ba509b47897cba0d3967a0829959e58e709093bfd702"
  end

  depends_on "gcc" => :build
  # upstream issue to support go 1.21, https://github.com/ledgerwatch/erigon/issues/7984
  depends_on "go@1.20" => :build

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
