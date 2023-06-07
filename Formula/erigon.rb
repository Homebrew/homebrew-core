class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "384f65a5f6bb4e1161ec0eca167c113be0854ffed074e6aa107bc6becc89bb7a"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b14e584da53c575bc10699e63c3718d62d45fc9855d793b57fd9ed7574af7eee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a16060d812a0c417fc5a56b1584401b6d5695cb1e01d105142e0d9b6a76cbd22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb7ba7eaa9721039301cee39fd4202ecfa72746f6cdee45d983ef7e7290c71f9"
    sha256 cellar: :any_skip_relocation, ventura:        "ea4456c71f348231500699436a11a760715b52ba164379140dd1a344403c7c13"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a24f76fb780ce8cce1bb8d74b6d2a9f985807f8f8cd7b20f99cadb62e3edcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d713d1d2a2752fbad361d53992c5d7f37235908346e83fe1a8b9ea5359960ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebaba7ebc24431583bc82aee5548e8a7907e9272d132ae81d8b3633683dba20"
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
