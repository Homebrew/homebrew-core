class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.7.3.tar.gz"
  sha256 "64a9f19eeccb3c094e7f9d2d936cd2d48aee3a2cc03148b980e0462c7579a73a"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c6d29677d3de3082978620bdcf7437b101dff2dd576c8f480a1756ba7b00ede" => :high_sierra
    sha256 "26e7b983b4dfc1d3d99ff2c4a8213ad35a7c5a1f8e5bcfca0ed28dc0e6f7caf2" => :sierra
    sha256 "65c9450164d5b3ebebed62e361244313bffd1f0d6665840508eb295135d70380" => :el_capitan
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
