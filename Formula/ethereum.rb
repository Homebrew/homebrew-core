class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.14.tar.gz"
  sha256 "cf1089e0316bf7b7705a43099b140d10eb5e556849d4dd9c7db101cda55e76e4"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2cdf2ee86d33efba67b5d33907e343392b1e5aa431a24d2b5e92a17a9dd79e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b167277e25a0af560499cee0800c632a9be8399352268cb8dbf9dcf23d349cb8"
    sha256 cellar: :any_skip_relocation, monterey:       "e00489607d873aeb45a808dae5b59e164a6d346b9b34a4295a1995030f8406e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4530316883adf1bdd2929e71fa094c842aeed604279a665be4c3c9feaeabc83e"
    sha256 cellar: :any_skip_relocation, catalina:       "ee8f1355be458a7a2d8d1e56ab67a6af0af46b5285ce2cc9653d372eee1d0d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb1a7a9fb636b968dcd31f6bb36febcdb028d14946573861394c1c1a2e924a7"
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
