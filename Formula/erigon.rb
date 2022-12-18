class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "965dc615d72e81981809e6e8c72e7fa6615962cf1eae7df45668714cc8486f90"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10259b11323d4a03801472efb747c94fa36fc642015ab3b7c22ad98315b35095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d987f8e76b9ca723bed6d2a65515050ce95d5ad5814d9454041b651419d5e890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e175e2c0c1c45ab7334c333f6417e83ab84703efdb7a192f140d0700d0cd948f"
    sha256 cellar: :any_skip_relocation, ventura:        "3cb5e6dd313aecac3614989633f032da1eec8cf52dfd802d97554b5adddab6cc"
    sha256 cellar: :any_skip_relocation, monterey:       "9b3c2829dd56ba0dc0b2ea80a6f51f4f269c1d85435acf070f3559ad7b6ad8e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a5d5a5e681352c193b944bf1e3719c492bc87a50c510f425e3beba3e4ce504a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa1dcbe5c6241d00375beab4979b23e220d1f543d3801619196dff3c26feef2"
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
