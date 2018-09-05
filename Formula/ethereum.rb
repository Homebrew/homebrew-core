class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.14.tar.gz"
  sha256 "4aa87bd594c18fec604db1804e69b303724b097b5b1021b2017ac2cf412f837a"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90bac97a4774e55a53f8f66e54c6ab487f5aa9c8cfc28a3e6a563f532979c38e" => :mojave
    sha256 "c27408cb9f82eeabe1d1332c19aed07b8a900c38e717842d14edc5aa75aec95c" => :high_sierra
    sha256 "7c3f235631ec88f3002d6fe35308adb8a886744c846b8215040d1b7f8d4b2ceb" => :sierra
    sha256 "ae500818deebb0d6d9949203b05b89b666ef4c54e4d2391bf9ac85cb38d1fee2" => :el_capitan
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
