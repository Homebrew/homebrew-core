class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.19.tar.gz"
  sha256 "3a5f4d6f2da037ccb8b864d76c008c33f0b226edf40f5fce1e3c0715a1619809"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4af6f7568b33fe01b1137369dee41fc409daad7ef9ea80c6460f19355116f6bf" => :catalina
    sha256 "a20c74bba6941e4612051f0a9ffea05ff220809644566c8d8b577af9fe93766b" => :mojave
    sha256 "143798cf9f88b9acb5fee1620d3a0631bcda944669937e3b9a1aa523fce434e9" => :high_sierra
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
