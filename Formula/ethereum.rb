class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.5.tar.gz"
  sha256 "6f17e0b4a41d321f1017ed6510ab35b447c951b9b1d0d400bfb7a980fac19692"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0467086a3569b816e3a2d1c2da528ed0908baddaaef62f5bc8e147a646ee8dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "01d544f89bebb693be7519984e72bf42be29a62d9679a1d7c3dce1514a69f7a8"
    sha256 cellar: :any_skip_relocation, catalina:      "e6c347ca332fd6a87546a5ce0227947356bc509747dca328a3b92727108d6428"
    sha256 cellar: :any_skip_relocation, mojave:        "f64c21cbe6ec70640573006de81fd093dbf34d22e5a7269fcd9c0025f4e959d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0283f2143c1de0eaa7d1366c62eb90595fdb7b878732205b46577c9e4a4538b0"
  end

  depends_on "go" => :build

  def install
    on_linux do
      # See https://github.com/golang/go/issues/26487
      ENV.O0
    end
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
