class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.3.tar.gz"
  sha256 "d16e8b42b37a23b448775f27f0d2018425e6a1e6fc215f764aad3665a20bf493"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "265658632786cf3ca6b4924f9c084fc80deadbc4ff405e38e41bd8d508f3a153" => :mojave
    sha256 "c65faf88a4a400407d2b123de95baa92b0a76eaabab454a5faa7d2c8b627e1e1" => :high_sierra
    sha256 "5927eea401f4a2ae68541ba3f8e549d34e90e86249eba621902bbff923c86566" => :sierra
  end

  depends_on "go" => :build

  def install
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
