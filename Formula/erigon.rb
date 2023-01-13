class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.33.2.tar.gz"
  sha256 "b7dbe352c533b307b9abc12a774609dcf87f324d2e5b245eb25844644a8ef5db"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eb2d9fe40edb34f6494a348a99ebe20e6ccf23a2ee8e52dd1b83c23ddae5cd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2276a429407d0af369566863779fe7446c6238fe6cc1c465c05c9ed22c8b3626"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "992e453e26c9c91dd1613d6404e10f4857a326fb2a9e442646e29614a8e6c830"
    sha256 cellar: :any_skip_relocation, ventura:        "db66f47720559ee54203224789dc634294e6574b69e605ad37f06abf34879abb"
    sha256 cellar: :any_skip_relocation, monterey:       "882a1a3b7ba1901ac42285ebf5c3ef3cbd9b5169d5e22eaad04490df32f2a035"
    sha256 cellar: :any_skip_relocation, big_sur:        "a020967a888200e89be2436ac2b6e78ac45302001da05a3662eb50e2b57cef5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bea10017f8dbbdc178a31db0a936deae8d32d2cf5058a3c155efa17df6a3bb8"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

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
    assert_predicate testpath/"debug-user.log", :exist?
  end
end
