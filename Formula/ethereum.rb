class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.21.tar.gz"
  sha256 "423c1cdd54033b9b12169977e6013d76088ba813fff8cc20d5f37ce817b0fff8"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e71915365944f8d0398b62671f74fe9c9d63ae056f132c7ee9c0feffe049efed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b504158b5374692dcd00b480dcd2eceec21d70155b0c5b30299f9990d576df9f"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c04e0000e101f64acbcda37eb3d2bb107d9d46f7420f165ba9e6f056860cf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "17599e37dbf31399d2042ce5a9ffe9da8b5cd9511583569b6bff31b51d740a8a"
    sha256 cellar: :any_skip_relocation, catalina:       "5eeef98c4d326dd367e4450006ac553c8192a7bb4fbf73bc3d80164403431bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d31f8742f8923ab0c2f00474e7702f46d0823025fe0364f5e4f723ebd8b44159"
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
