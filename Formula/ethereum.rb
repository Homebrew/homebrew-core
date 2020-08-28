class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.20.tar.gz"
  sha256 "61669258de88a641585fa268775fab5984e1eda4035cfcc1955f1dd48e7eafbd"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url "https://github.com/ethereum/go-ethereum/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6dedced5cceeaf7f02be2278a208e590c0e09d14b3a342cc4ee9e73e69ca6ac1" => :catalina
    sha256 "a1e119cbf1d323b89819fbd606f5a5166b0ad65e5ba5a3bba5bc1d2255465313" => :mojave
    sha256 "40653d6f291db8bbae18321b0bf94fb19d091b4f57e51f9d14ae1e73bf07df09" => :high_sierra
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
