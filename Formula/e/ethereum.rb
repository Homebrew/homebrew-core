class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/refs/tags/v1.14.10.tar.gz"
  sha256 "ec6c55c00526dfe38d9cbc327ea32c239de09cdb61b3b7ff4a90104aa36e09be"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432697a5b2d6c8cb34ad2107e3d5a59c86e8155058cc0740692a602fe41557b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed69ef38ea995a6f41b5870eda0c29c0083730e7f7cfd5c8f9e3c42d0777b8ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c0c82ab7a3eaf815f5a4bbbf85c447f159882319c6550ce6addb22dc7182a7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3867af12dadc254986127ee4a8b3f05d63e476a53162252587e6aab648ed944"
    sha256 cellar: :any_skip_relocation, ventura:       "7e24c482e27de7825c101004cd459f39dc10074aebc52c0ab0bf28bea551c633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09cb3ab769e823e93ec17e2a1657c574482b8ffea2b2bf539ba394b3e863bdde"
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
    assert_predicate testpath/"testchain/geth/lightchaindata/000002.log", :exist?
  end
end
