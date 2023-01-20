class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "a6f8449649fd01722a0a4de0e265a93c69a21ede55cdb8370464b65321c3d605"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f50af05f2e59e2f62ad79f1852e82c5a7afadbba6b9075b7237545f6a92ff43b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47f8fb3925b47e562dcdf8f13faa4ca1a76a35c5baaf07426847cdd26688d0df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f3a619b3fe00e183622cbb9f5045dc3455b083c34064e8f299f053d070ae6c3"
    sha256 cellar: :any_skip_relocation, ventura:        "e0035f35566f8a5ebb62e2a512e788818f4df2f4ea08f4ef71b9a771d2605e7b"
    sha256 cellar: :any_skip_relocation, monterey:       "1170a3339bf2d1667904dd817edb1fd4bc497021b60c6cc64d9bc6a88a141bb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "90affb9329f991d41c955a2e7f60f72321beca327f97fb17c12650a60c5f49e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69096ff1ada60729315badb049a11d9c5882182a53f49e6491d2dff1453033e0"
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
