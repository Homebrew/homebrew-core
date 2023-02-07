class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "9fffab3dc1ecc2318bda181e73742c76406c0c825b5e1a80fbf3562c7ea80e5f"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de5bc7ac18c6622708f14275db3946a24dbaa1af1c9770b6fd437f3c9cd26e28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "419d2d85abbab7008283d8cae0c16d0942643d2528f17b07dda0d1e3e4c81cce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbecd791ce255caa7c904a40a32d996f8a46afe09bfe318e905d67cf82aae69d"
    sha256 cellar: :any_skip_relocation, ventura:        "f2248e45aa9fa2b20fefcda7196715180464be349901302e3c917be7ace41b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "47183c411aacf0ce7c91e8ba92c21fe59f574ab0301193e6ea45d48f1797b0e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7829ad62d40f5b2508418ca0b3c8354aba3e76ccbd67856af4511555b6cd82f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4068266d76837f06c9289871aaae07012b79293ec6f9da18e1fc8ee8d665a32"
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
