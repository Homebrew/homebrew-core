class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.10.tar.gz"
  sha256 "e6536971748edf13d8323c4c491c72d6628a99f8f0b1242a46a7ea9c859f02f4"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47b5f1099a3d4b9d373b112e6f0e4eb3b2aff332385a0e12fa2a684a25f06387"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a8dc7b87d5c11599d3791a4b0010a56b17b895cbcc2a0f123fe57588c744adb"
    sha256 cellar: :any_skip_relocation, catalina:      "58109822d3dbf4284cf40ac22454fbc1862f2be00232cbe0c8fe5828ecf001d4"
    sha256 cellar: :any_skip_relocation, mojave:        "5120a626d2ab141ca1b072b1dc7cd85b27f1849d44fe0d4f90583b1103e73e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5e19e396af36c31ead3c59ee32523860b34c0a5fca092b9b70b82f8508e4c6"
  end

  depends_on "go" => :build

  def install
    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

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
