class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.7.tar.gz"
  sha256 "5bfe24930e2837106994d2fd9164cde8ab1ad9159a97bfcf0e466a963653e0b7"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "487fec10b9db0273858a277358303a923dfa303281cf8e8e5610efb566b45132"
    sha256 cellar: :any_skip_relocation, big_sur:       "c60dc5fc165a97294c542a0510f5a16c8b9c8679ce80a59257c231976724913a"
    sha256 cellar: :any_skip_relocation, catalina:      "93dbe42fcceac701af0a5f22698b0039bc6d0a70e1a3fd745ffade41f901cc61"
    sha256 cellar: :any_skip_relocation, mojave:        "1bb62dd4bc2fe8d68f335e8c7f5b9857d9c77c0ecffd7dc17e53f6c3b6ef130a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a5a18b863ae4435698197f91ca16a41e995e9f0c5e80dd155e987832fe9df4"
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
