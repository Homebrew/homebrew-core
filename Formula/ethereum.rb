class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.11.4.tar.gz"
  sha256 "d62b2da50fc3ad8e891c73900c9439eef3c0884aa304e9bb8eb196c461c40d6e"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c4f696f7d87f199ab0b0ec9ae55894486a52710a215dab5dc74a8af2c5b957f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a76146657670ee6549358c659dd67b829605e55bb9f5ac1ab7a92cca570a6166"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13806b1ef70fea123db5452ea51601e49df62ba972410d69168e8ead78f92345"
    sha256 cellar: :any_skip_relocation, ventura:        "5f838d238c98eabbef2a778804701cd84c2317b477b503dfe32d57d974318999"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd4f8531724a838f523a9ef1647bde5065700cd50d3703ce9532eaa12a8f936"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc4a61ce01a93a644d563ce3e4086351f766e84ab4fdc61f134f9cc68544f766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff5881936ae34b0af731bc3b795874900729cf726d274db7c2e9af4924bda3c"
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
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
