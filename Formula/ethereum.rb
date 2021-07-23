class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.6.tar.gz"
  sha256 "3724f09a5c34ff5f71a37bac7b52faaa04457bab46a005f8f2fa6ce68ba5f632"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c4c249151395ab6d3f0fcad0e13c47d1c00cf3a2d45c1dd4d2813cbad2069174"
    sha256 cellar: :any_skip_relocation, big_sur:       "a124affe0295da28a8c8c3f03dbc886a144d8dc265f99ecec918baeec3614275"
    sha256 cellar: :any_skip_relocation, catalina:      "50c6e07967696ddce58d71daaac4149065d3a585087201ebac0cf150cdb43920"
    sha256 cellar: :any_skip_relocation, mojave:        "4007b8a99d95530ec16717e51a0b10d4198f5b5ecc5e1f861d89e6bbd357cd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0f3d4a4a0faec477b5338b1ae3eea9c429abac99359f870cc1fbaae610d832"
  end

  depends_on "go" => :build

  def install
    on_linux do
      # See https://github.com/golang/go/issues/26487
      ENV.O0
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
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
