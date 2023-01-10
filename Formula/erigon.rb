class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.33.1.tar.gz"
  sha256 "6a39ec9d5c6c2ebbad899cf93c29440392d86b116631ef2ce7dcbb7a536e5614"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b967e56d1f73ed6abbbdca1b6b1ece21012676349db8177d0ded9428255ea853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301364c7a3c993976dc4f4db4b112b61a9889758d0378b565645a4dfc9614b17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd0843112829fde04d11c859436ec520b5a31b2c8197e0505ae423b8dafdad14"
    sha256 cellar: :any_skip_relocation, ventura:        "7e8a01c6fa5cd216e1e9c7fd952a67e4d897e1cd6dd347effb2124cdbb289a39"
    sha256 cellar: :any_skip_relocation, monterey:       "33dcd0ec47836d1f3370a60d99d56749f7da29ba655429397a986887e7a592f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d208c80a03011b9f35386ff7a2da7442f17ebddc675a93f4381c8f48b97d0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc4563f81339afb5f8a637497966d9b63022a5f9d33f432a6faea3dc562d1536"
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
