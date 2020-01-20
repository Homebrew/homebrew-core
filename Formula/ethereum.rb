class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.10.tar.gz"
  sha256 "d16afd0686a083e2bb3c18862c7d736505355e42edff4c401112dc643c4fad15"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "48eafc1a4827c0c9afa2ffb2a1c34716ddee6da12d53686f0aad528949129c9c" => :catalina
    sha256 "e5d854fc8e49f6249cdc0b1448753918cdf6aeea07fff29f2b95c3a1c0c671f2" => :mojave
    sha256 "f1dd7a49bd74c46ab3291feff7734a659da3c65f54a93e6efcbfb786ac47aa96" => :high_sierra
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
