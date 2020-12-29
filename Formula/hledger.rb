class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.20.2/hledger-1.20.2.tar.gz"
  sha256 "7915448f4e8d04ab3c5dc659111f1114316f804cf33f3a114bb1402e956967d6"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a11422281e204e2c774730b7c2649cf1121144c0558c585109f966b5ad6a1040" => :big_sur
    sha256 "180507cb694ece066ad41ec372964d680f640e319b52417286cb0f10a388f876" => :catalina
    sha256 "082b2a84a44cd32999b7e5ac95f414ea7409001880e3aa57c23cbcaa1f29cbc2" => :mojave
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.20.2/hledger-lib-1.20.2.tar.gz"
    sha256 "2bbc51be838162be6e85849e9c5a23f7937085901071a801901abe38a5343f82"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.20.2/hledger-ui-1.20.2.tar.gz"
    sha256 "fc17b080c3892f5166b5e6278597d1aa3a0fe02990de46cbcbc3f675abfc41db"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.20.2/hledger-web-1.20.2.tar.gz"
    sha256 "ae07ed6d0adf96157214694c356b3121adbc3d9bbe7312339adf114f9ab62821"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      # For the moment we use a custom stack.yaml file to help build
      # with ghc 8.10.3, which does not yet have a stackage snapshot,
      # and to declare some needed extra dependencies that are not yet
      # in stackage. When stackage catches up, we can drop this and go
      # back to an install command something like:
      # system "stack", "install", "--local-bin-path=#{bin}",
      #   "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--resolver=nightly-2021-01-15",
      #   "./hledger-#{version}", "./hledger-lib", "./hledger-ui", "./hledger-web"
      (buildpath/"../stack.yaml").write <<~EOS
        resolver: lts-16.27
        compiler: ghc-#{Formula["ghc"].version}
        compiler-check: newer-minor
        packages:
        - hledger-#{version}
        - hledger-lib
        - hledger-ui
        - hledger-web
        extra-deps:
        - pretty-simple-4.0.0.0
        - prettyprinter-1.7.0
      EOS
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"

      man1.install "hledger-#{version}/hledger.1"
      man5.install "hledger-lib/hledger_csv.5"
      man5.install "hledger-lib/hledger_journal.5"
      man5.install "hledger-lib/hledger_timeclock.5"
      man5.install "hledger-lib/hledger_timedot.5"
      man1.install "hledger-ui/hledger-ui.1"
      man1.install "hledger-web/hledger-web.1"

      info.install "hledger-#{version}/hledger.info"
      info.install "hledger-lib/hledger_csv.info"
      info.install "hledger-lib/hledger_journal.info"
      info.install "hledger-lib/hledger_timeclock.info"
      info.install "hledger-lib/hledger_timedot.info"
      info.install "hledger-ui/hledger-ui.info"
      info.install "hledger-web/hledger-web.info"
    end
  end

  test do
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-web", "--test"
  end
end
