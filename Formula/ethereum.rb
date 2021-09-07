class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.8.tar.gz"
  sha256 "d3bafdb34958463a2169eb93d8d106ae0ed3a29f2e1d42d8d3227806c9dc9bee"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09edd31847cbcc3bd080134a289e69fffd931c9d1caf5fb0f03561c0787e7da5"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4cc07a6b9f3ea0312d6a18c14a31aca03e9d71ef804b2699e0649900ca8b3b1"
    sha256 cellar: :any_skip_relocation, catalina:      "3b81f6ac21a65419a51feb474c2e816df2158d9699fde426f8767d4e9128342e"
    sha256 cellar: :any_skip_relocation, mojave:        "ac19938b0a69af4311b3ed66909d84a43cd000c2b602bc69a0a795de28f9f7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f02de0f38664ee2ea38d46bc97c852bad878215454dd9c0e8106deed73d9214d"
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
