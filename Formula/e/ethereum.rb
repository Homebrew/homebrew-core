class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.13.4.tar.gz"
  sha256 "e74d320fe96a40686832ba0a84b6d492e30a3cbb5c156b61b52bee8edfdc6414"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78819cb51f6020823aa0a74a3d0c937ff600d30640da846293db0441526f06fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "375898ca281f98f1695272eca8079b7b0433c6a2054bfcc845d0fae6eb3c341a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0ac7eff42bb37771510f274a4c84e817623f247b2d1bd960345890b94189c24"
    sha256 cellar: :any_skip_relocation, sonoma:         "85bfec21110c4abaffb8a3ad83d40409dd6a7815d18901398541a260266ce4a0"
    sha256 cellar: :any_skip_relocation, ventura:        "f5791ba33ca25d936f64a40876eb16545e09442e53795b6fd09ef153e79c64ef"
    sha256 cellar: :any_skip_relocation, monterey:       "5c212d1c8edcb7e1f929a1c91a5037b466e1f736f89e66dad8bb0c75a5383d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e5e869fad10127930967f7a282dfd8e845a0859bcc78a7cdbbf2eedef722c9"
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
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?
    assert_predicate testpath/"testchain/geth/lightchaindata/000002.log", :exist?
  end
end
