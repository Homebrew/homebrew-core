class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.3.tar.gz"
  sha256 "693d202e3ee4a989c753ffd5032572621e3ee243eb344e6d0bfad5e2fe4ffa0d"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3debd58540f0e5d0f3e9cae30faf1a6d16d722b838b57da1ac4851f056c22c69"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8da134f4d24b93c85be03c98174c212e4b6fe32ea665e5817ebe845bba29c14"
    sha256 cellar: :any_skip_relocation, catalina:      "7f809af99211ee59173006551b3c11b78e2c55e8270dbfb3bd4097dea56270a5"
    sha256 cellar: :any_skip_relocation, mojave:        "390242138ddd8e882edb8d20f944435963e3c57797c189338c33012dbe8dac66"
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
