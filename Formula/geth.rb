class Geth < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.7.2.tar.gz"
  sha256 "456ff0e6f495a69b4df11618156010d6f26ccbaba39e544c95108942b10897dc"
  revision 1
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac63d73e7fb31d1fcbbaabbc272ca9bb863ac5f2392bfb1f8326e91fac348674" => :high_sierra
    sha256 "ddfd4f4a4a9f447b5019a03a2bb3c04d62932f1e35f0f080543e5d3a26fd3f81" => :sierra
    sha256 "cb77fa093d895ba7ded724e2b78093f09a03cb8aff403b7abf14a301a35e2f07" => :el_capitan
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
