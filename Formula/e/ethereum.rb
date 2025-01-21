class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.12.tar.gz"
  sha256 "9f9deab753c072cbb26e8a14bc245760225c27ff6a9f397d25711f403c138d54"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b04d2147abd2065f5b93963614185bc752fdc6b27a2b4f37e700c7a3ff1a2496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f54065d7227192453026e4977269ea28c67b0b0879779e8f638b38bd3c4b2a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0719bbd021439aab359269ce2bae3e32b95c8839202ddc8bd54bf49eb46544d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ebc7201d85fe282b0ba2fd69397d74deeb0e75b012dc76a9f88c85052904ff3"
    sha256 cellar: :any_skip_relocation, ventura:       "f84a3659f304f0ce0182a65e6b575792261c2b5f0bd3a7e8cfc0265b023fce57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7433219c7eabed827497e02745e2f949f81a0db2ab4791d82f7befb98e82f7"
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
    (testpath/"genesis.json").write <<~JSON
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
    JSON

    system bin/"geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000002.log", :exist?
    assert_predicate testpath/"testchain/geth/nodekey", :exist?
    assert_predicate testpath/"testchain/geth/LOCK", :exist?
  end
end
