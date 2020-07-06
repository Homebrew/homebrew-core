class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.15.tar.gz"
  sha256 "805b896f4055b8e1b7a295608e2135f93e45f75ce821eb07beaf2acd2e24acc8"
  license "LGPL-3.0"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f1d5e71008da3e3b306ea1fa8ff7c17d755ae2b070f2739e84c9e1fffb31539" => :catalina
    sha256 "5d8d5010770b8955b93ee47085b0f7a6167431d26d34c7b95b8d5110742f1c57" => :mojave
    sha256 "74dcb4d34eb330406b425af319598f3066f19ee3af7cece2b809459cc70d5e36" => :high_sierra
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
