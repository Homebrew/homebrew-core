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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f69a29cbedb2bd66a0626358daa434bcc3e22f8f3ab4eba6d47bc79ea6411178"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cda7efa39e1057f6596969ba769a4ffd286bf9d845ee27a0068fbdcdb9a38b11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ea9105bf61bf0ecdd362e0f1a3f1924eab42d68c8ae0238e5625adb09edb156"
    sha256 cellar: :any_skip_relocation, ventura:        "ffdbe2fda65c02fa584e92be560a95ffe9ad7d0f095021c3fc4a665d52f51c75"
    sha256 cellar: :any_skip_relocation, monterey:       "1297472e07310d81d8d113c6ff50347f96d62a4a7af9565a7603537dca45b6ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "18d123a376dc3e65b218969e3076433e262e846d38e37dc4dcfb321ffd3a1004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb16b3234dc801540fe9eac5a267c35546faebd4cf60968b06d15410d99bf1ad"
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
    assert_predicate testpath/"debug-user.log", :exist?
  end
end
