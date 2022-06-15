class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.19.tar.gz"
  sha256 "4aefb4a26d2146c315955f714ed0d14bb0358c95ff6bad99845678263555c7ee"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "791734a4e7284575426eee979c3d525e093d11eb4cda5b936facd119fcc4de41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9718114ab06b74660cbe61275bd37903063675481d8af45ad67db0dd7fe98e7"
    sha256 cellar: :any_skip_relocation, monterey:       "bb8f80137aeff39f08fa8800d58f8fffcd3a2e5cf4bf12356ea3478262b6185b"
    sha256 cellar: :any_skip_relocation, big_sur:        "70e10eaff96a1ac8a43bd7a4e7edc915164843be8f4d829070544b9bf46f1335"
    sha256 cellar: :any_skip_relocation, catalina:       "2967843c209c198236211dfdbb5afbdc410a2f817bfb1a1ffb7864efc781095a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e6fb10904685eab31fa2251fb0b5b4da5dd5bd60efbf0c2f0baf40cc0e520f"
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
