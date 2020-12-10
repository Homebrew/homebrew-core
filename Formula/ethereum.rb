class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.24.tar.gz"
  sha256 "5e5d69dafc0c93af47fdc5fae782048b15a3a16ac722db39c9cda2eacdf21234"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c60f35f487ad161fa35dd5eb304f0b20da30c11fc87452af547d5e301d24331a" => :big_sur
    sha256 "356b50d24fbc8fec4e6a31034b50fe87a5e6b0f31c9ea9c3444b1167b292faba" => :catalina
    sha256 "2300c69b86d1d2ef2a9429eda443e1f1ce9fb65b8bef396b130f62524050c134" => :mojave
    sha256 "d30887aa98334ca55994bca6aca1e865d02ea50a330a99b024c2c305a0415740" => :high_sierra
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
