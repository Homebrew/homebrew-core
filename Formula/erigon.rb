class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "4abbe03ab1517e954e20a19d44689bcddc598b5e997c7b27ece8643d201addc3"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b840cd31e04ebbf07ef9fe9bc5aa20131b1a72416b6418d849d9ce5769897821"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8e43cdec391b2e5782330922472b6c027bb174979569c14cf77302013705e67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9955aeb348cf89e7cf0a188aa0969f70b0904d48beeeb83d1e890e8e377bdc9"
    sha256 cellar: :any_skip_relocation, ventura:        "de9dc53b6f0d7ba64bfec5151f29fd36473afd4a2915e9d22aeed6e79b573a8d"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e00293887feab722447fb33f0c090103fe540731bc2f8a34b2e5f4f37e32b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d935d247dea1e4b367ed9578678dae66afd6a15c0d9d531c23161a65681f933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f43ac6d1469f8be3e1a026254bfabda011998a9c943556e95156cb8c14ba2b"
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
