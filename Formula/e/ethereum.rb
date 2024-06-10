class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.5.tar.gz"
  sha256 "d062f7206769e2b3acd851d9d3dcfbdaea39dd379f95af3add7114fc2e7264df"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "222f58e9c27b17c4e211555cd083dddc73bd46688cb4b4e040ba8226a08f939d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed65c7aa84e35bcc715d5da3d6463e5c2525d1314b98b7c5d9b11613df6d7a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83ceb1a827bb1ae167b93a43e45243db477068e00c6f02bf114e9b30ff53a738"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccc083ac3fac4ec3f3a0e3c38c1b5267b7dca0f10eee1e25cf36e244ae6c664e"
    sha256 cellar: :any_skip_relocation, ventura:        "e34aace9b32e88377be28bab47d14049e840c3059489fbbde33f61c822dd2462"
    sha256 cellar: :any_skip_relocation, monterey:       "48ae37c23ef3a0413538558f11c8e71190b9a29dfc9f5b272ec574bc063df827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7a944d795cd87b5af338328f94c397c323de81eb5ef9d0340393d068048797"
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
