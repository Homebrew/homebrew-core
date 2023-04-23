class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "7af31bf972d24ffb0e1dd15d0ee1106619f4b9aeff8cab7885f306794f5a7776"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db55bbda691fbd5979e33e0e9e8edc5ccfd0058a4e6b08182415cd757da59383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c119645ef5df7199a660be6a28297117e43936a41de8870fa6fc4b2020dfff82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e55414cdde0676527ae427d03ffa661e75641a6e34202eaf0bd8fbb0d5deed88"
    sha256 cellar: :any_skip_relocation, ventura:        "d245827e37ef382d55d332edb63e2a1de397e4ccbc5fa1e0b9d959e6d8ffe727"
    sha256 cellar: :any_skip_relocation, monterey:       "51fb4d079fca1a49cf28a1ee202f4a871b28fd2c6aafef7fc3a44a4c0fd38d98"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7827fb4988ded74c92872ef85480aff17d9857ed806aa44fc9e28c1d7c92bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de08be3ee3f795b5e6a27e698daf2d9280530d3ec8924834f82d26424c43fdd0"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  # patch to use go-m1cpu v0.1.5
  # upstream commit ref, https://github.com/shirou/gopsutil/commit/13b3618b1e1ec41a142d594990c6f62ff1540526
  patch :DATA

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

__END__
diff --git a/go.mod b/go.mod
index 38a4f09af..2efcbbd93 100644
--- a/go.mod
+++ b/go.mod
@@ -233,7 +233,7 @@ require (
 	github.com/rogpeppe/go-internal v1.9.0 // indirect
 	github.com/rs/dnscache v0.0.0-20211102005908-e0241e321417 // indirect
 	github.com/russross/blackfriday/v2 v2.1.0 // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/spaolacci/murmur3 v1.1.0 // indirect
 	github.com/supranational/blst v0.3.10 // indirect
 	github.com/tklauser/go-sysconf v0.3.11 // indirect
@@ -270,4 +270,7 @@ require (
 	rsc.io/tmplfunc v0.0.3 // indirect
 )
 
-replace github.com/tendermint/tendermint => github.com/bnb-chain/tendermint v0.31.12
+replace (
+	github.com/tendermint/tendermint => github.com/bnb-chain/tendermint v0.31.12
+	github.com/shoenig/go-m1cpu => github.com/shoenig/go-m1cpu v0.1.5
+)
diff --git a/go.sum b/go.sum
index 5b2a3ad89..7aeedad33 100644
--- a/go.sum
+++ b/go.sum
@@ -719,6 +719,8 @@ github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQ
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
 github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/shurcooL/component v0.0.0-20170202220835-f88ec8f54cc4/go.mod h1:XhFIlyj5a1fBNx5aJTbKoIq0mNaPvOagO+HjB3EtxrY=
