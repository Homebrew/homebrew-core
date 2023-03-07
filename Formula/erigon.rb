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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009a359edf6e7a8d616f3bdf89e7b0b7edb3bc4ca4203ab2ce3ad3ad7a849477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9141b41c108f6c0f32fb37ce21d37522c5ec2a8f66a01244cf83edab381ad09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b25d711e188491f9b69aede1ac39072a3d61f8d7f0b517dc663edea31af5669a"
    sha256 cellar: :any_skip_relocation, ventura:        "3a77fc64c4c33f27d9897d52629eda4eb817bd50bbf1028a3f944b3f10294da3"
    sha256 cellar: :any_skip_relocation, monterey:       "4364a6caffea33ff4e31d3e6c0f7dbf5bbccee54f242172ac9dc41490ee009db"
    sha256 cellar: :any_skip_relocation, big_sur:        "a49b7f1c5f7674149dc7f84e90645a263875472131129b5d454c8bf00378ea63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af0e7099eae245332da91cee2f5b7ba350eb2c0239c959c2ddaa65fc4559c277"
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
