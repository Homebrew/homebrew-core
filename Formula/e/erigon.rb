class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.52.5.tar.gz"
  sha256 "fd99c18bf6997f77d0760cbd8651b10c7e037ee540b214b86e24774a6770357e"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4add907afe6f15422ca637c66d17e30f45d757321f901c2d7d08d5e45dabca97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ca8a0f501e67a2c3c776b3bad8f8d7b4c02b1fcf1f6f1f33ee94c869a0a7d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6db0e272ff15e3849e63be1aa0f4dd9b1c398341d54c1461f562c12c77cadad"
    sha256 cellar: :any_skip_relocation, sonoma:         "b94e049a4e49753ecd6dbd94c0f63d08438f265fa36fc1e63b3352656e27a881"
    sha256 cellar: :any_skip_relocation, ventura:        "203748256c7138d511889a387a044dac424a8d37124c923802d584b5969e1f22"
    sha256 cellar: :any_skip_relocation, monterey:       "18b54dd60583024f238a474dca5f5a7836bd8d2f94abbab212fb3540dfd40a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c01786ebec4e83969bcd998b7ae84a2e3e241d8989e4e4ed1b19cda5d481a5"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build

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
