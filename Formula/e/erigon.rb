class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.58.0.tar.gz"
  sha256 "328bec2af8b3771e81b23a652a94755e948d68c4553bf0dd00b0dfe1d5f41366"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae35586de98a7067a18a36323c65a8573fd2a5cf3c4467efa1daa7f625b72edc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b3595711fe008717c82ccfa82836e9753f2319b7f66c2848ee4f891879737b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e976d99a3ee32f34a3fa3dedfc5c84dbe348781034c72ba26510c954ca1076d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fe3b15261883faf113b87f3373d9b26e4119c607c456d6ac62415974534b32e"
    sha256 cellar: :any_skip_relocation, ventura:        "6a0bbabd1ab15aa833c7311b3d13fbf176002fc5695e26ce9cf5a821f1f0e9f1"
    sha256 cellar: :any_skip_relocation, monterey:       "6e2fe466bbb29af8ef4d9d5f06767ac32188730a3bb276b9f0cfd4227ed64acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66f64987e1828b5098e40d6ec7e4fe4ece0240059d2151abca6f9959f6c88aa"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  resource "silkworm-go" do
    url "https://github.com/erigontech/silkworm-go/archive/refs/tags/v0.12.0.tar.gz"
    sha256 "581d0068c132abcc2c9d40cc9e054536d099df39bbdc2b83f7fc148e87304c0d"
  end

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "Homebrew"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

    resource("silkworm-go").stage buildpath/"silkworm-go"
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    suffix = OS.mac? ? "dylib" : "so"
    lib.install "silkworm-go/lib/#{os}_#{arch}/libsilkworm_capi.#{suffix}"

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
