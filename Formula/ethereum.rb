class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.25.tar.gz"
  sha256 "d7b733aeef4eba97f5351ba435001fa7365f55adabffdfdda909700335e98b0e"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "236e8976bd37896135951f14345d2c431aa30c35c06a8f564ee0d1890dde6e36" => :big_sur
    sha256 "cb6c2c4ef5992fcd944887052099d846e865b29486152f3eaaaeae7b64a97770" => :arm64_big_sur
    sha256 "c94e46a6bea15393eb22e15bd4bbbb63cb08db493989b2008aa16c5b9106d3f1" => :catalina
    sha256 "0f1a9478c1873537097fa246ed25956d606df2b91939bf2d98102a95fcca2b96" => :mojave
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
