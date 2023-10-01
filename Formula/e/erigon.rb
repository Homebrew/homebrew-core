class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.49.2.tar.gz"
  sha256 "8371f6bd9fb45e5a4635579e925edb11a48ff9647b464d93087ee6efb7fc9fd4"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e7b2bca3c4e778d603b60cd9449832c986bb1251c0e7adee498d80019e7ce65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "710e40fd05bc27b230db2e8352db137e9377781ac783822a1998fde091efb8bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04af9a028e8b0a2b3b5c665d8fa6aadb2fd75b53c068b32d6a587b671620737e"
    sha256 cellar: :any_skip_relocation, ventura:        "83018c73a41ee9eac8763ef0bc134ccc54827cd8593d2e68c8cc3b9437fbad02"
    sha256 cellar: :any_skip_relocation, monterey:       "1278e2b55aebc98ed85bde1d0d41d1a6dcb2f46f22ec4e5bccc0944327879881"
    sha256 cellar: :any_skip_relocation, big_sur:        "53600fb52aee086277e7772cac2af4259bc02bdc387d4708c2d87f4c5e88ae8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c51cd35dd0203a8f89a4a07c78aaf864f48c9df51a597b80d4fbe47aa25c88b"
  end

  depends_on "gcc" => :build
  # upstream issue to support go 1.21, https://github.com/ledgerwatch/erigon/issues/7984
  depends_on "go@1.20" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

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
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"erigon.log", :exist?
  end
end
