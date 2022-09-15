class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.25.tar.gz"
  sha256 "29975104c408cea71f40911e804d7bb629770734205d0f147f2993603a10204c"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8218c270b2982a7467203855bc1eca235081d66ef30fdceb5a318b9fb2976e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59946542921a5b504e43fef9aa4075b45c4c2ccd5e204385782b25169ac9ba28"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb7b477fad7bd9224ec67d4a4412ff8f8f0ea6af516861b7303ab32596748a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5392600f509c1d4d1e589f0ad5f20e99bbcd997baba80406763e9374a40b6cdd"
    sha256 cellar: :any_skip_relocation, catalina:       "53586c92cec86f4724a495f08f06531cd25614759f88c74793d0efb9e75a75c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a706a1eee5a17ce0b254dc18090827cb033d7ee512a37433f777fd3f831593b3"
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
