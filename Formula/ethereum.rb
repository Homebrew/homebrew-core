class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.4.tar.gz"
  sha256 "68bf82e8c93e139ca2500a30d432623b3f56e76006c0b0262d88caae5ef5064d"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6cc701ead59d6c9c64bd7f144ce2578223f7c9861fadd7fa69cc3c0a19423f9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc41b9923218f988fcb50375840d55d097d224b1b895049c5eb38f065e5bef3a"
    sha256 cellar: :any_skip_relocation, catalina:      "d04acc886604c978009c4c1ea6cee12eba388392863ef5050cbd63e449b113ba"
    sha256 cellar: :any_skip_relocation, mojave:        "49b93b0076d62eb4ce3a7a4dffbc496a78a5700a58fba460e07c52ec0f95a466"
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
