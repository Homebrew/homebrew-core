class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.11.tar.gz"
  sha256 "5e4cda78d8e91d7787283d447243011f7b73612a5f84b7e67ac6bf237835151a"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7241372c6bdaed66a0e8f40569036857a40a089e798d772e01415e758226e185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "274a86f59944d540f6b7fd4302ddaea377429a107a4e6d290bcdb8d8fff2df06"
    sha256 cellar: :any_skip_relocation, monterey:       "10df1e0c366aae8ab7dfe021963eaaf09d3a57d76990f88ab455943cb9d13911"
    sha256 cellar: :any_skip_relocation, big_sur:        "7789bda57278ac34dd9af5b34d427fd8e3c8fbd40e9af70cd830bbd6a80265f0"
    sha256 cellar: :any_skip_relocation, catalina:       "c58961e4b1f42f86ed7b12dc72a758ca0812046c4706cfa5162fd746a18ee108"
    sha256 cellar: :any_skip_relocation, mojave:         "44bb894da43ce80ae97001af5f39a87225b1922d031d8b09dac8e29d065f0f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76cbb54390a3d4ba42ec842c96b8793145ce8b5163c5e84ba0759ba19b71347a"
  end

  depends_on "go" => :build

  def install
    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

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
