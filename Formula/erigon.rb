class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "fcc0693070d668a0a7256dd6fc29ba268292625101f60a71ab91204b9128ebe3"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ca82d38ba789a574c461af6e44765a9aaac2017bb323dbd099c6a5680194385"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7f4d6a468fd7742c69fe9b14657136d6450b420a3609aae3e1fecc7462aa66d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c4104e91faa9738a0932e3c6e74063314a5e49b78ed8c5f8cfbf21dc00d1938"
    sha256 cellar: :any_skip_relocation, ventura:        "8f4cbb4efb053d0cda4ae4196292141f17cc8e6bc43f5bab1b2f7953162bf77e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e346733de8fe6d11b2665b9af83da271e9062cb1bcf8d4e5b412b3998aa5bc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "17148add5a4c95e0e636b58fff55280a5a033c9a9edfc962fd9abb0fbe29a14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea50e7471e50586c4dd813a1be040e121ab74bcc0fe5959b3ae8435b98d29a5"
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
