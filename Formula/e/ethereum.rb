class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.11.tar.gz"
  sha256 "4c21982453b1046e07fe68533b2a9d6d7bd7fd618ca8c1d990e6ceebe04ab4b8"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d952ce94bc777bb27924b64145c27862b9aecc2ed6a5cc59392f77926a7b7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc56ca8f769248727f858c74da1828b8ec7700206d52290f9d0d5450661ee4fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2676795edb6837a093d2f0168296c8cd51b76f04f74496d5618c76c6cce66cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a77e79ce7cda0f9823c19ca4f7159a2d3925f9119e85e03af4882af3589d275"
    sha256 cellar: :any_skip_relocation, ventura:       "4e8f073baddee18d9e4653b2e4c720ecd5762855d859517782acc8e279f6babf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2438bdfa5badc6e41d0d55abf760e2142276db79ff432650a0094df928bea57d"
  end

  depends_on "go" => :build

  conflicts_with "erigon", because: "both install `evm` binaries"

  def install
    # Force superenv to use -O0 to fix "cgo-dwarf-inference:2:8: error:
    # enumerator value for '__cgo_enum__0' is not an integer constant".
    # See discussion in https://github.com/Homebrew/brew/issues/14763.
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

    system bin/"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?
    assert_predicate testpath/"testchain/geth/nodekey", :exist?
    assert_predicate testpath/"testchain/geth/LOCK", :exist?
  end
end
