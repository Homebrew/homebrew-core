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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee4746cac2ac03ae1c88fcfd636aa6317b49a1ec8ceac492253d772b919780ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "70b159a7c3eff639e7c57cf1c9134c145cbbaec828062b791f6440cf328fbaee"
    sha256 cellar: :any_skip_relocation, catalina:      "18b35447cc07af5a1c693afbc1287caeb316e6658df65027330a0f634c2665e1"
    sha256 cellar: :any_skip_relocation, mojave:        "3f612f141a775621dd5e44382b58ef6d22d30dccd8989cee1f20e43abc41fd7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61b07bc48928f74c094b83ca4a284c5f6049c060f139ff9352f916ac694b11c"
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
