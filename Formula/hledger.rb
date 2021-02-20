class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.20.4/hledger-1.20.4.tar.gz"
  sha256 "25e155fcee541e9c5a295dc5002b03f184049b80485b18901d9d660a26814dbb"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3fcdfd761351cc052d8e88477288056592559574bb45605c3fa5674a2df0dc49"
    sha256 cellar: :any_skip_relocation, catalina: "9d4da9897d54c3d5a92b1462d5583530dc6aaf789bf5248020c93a7469bb4e4d"
    sha256 cellar: :any_skip_relocation, mojave:   "41634adcf3e65ca93e31ffbfc048ca45e6b6282a546545bf0c1a914ae86c9343"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.20.4/hledger-lib-1.20.4.tar.gz"
    sha256 "dc7f00517d33062ed9c495dea6dc20181a0c4fd1805f2ce37f30743ea01cda9d"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.20.4/hledger-ui-1.20.4.tar.gz"
    sha256 "71009410e2267377ff572b04f0ac860c94c75ba1c58c0f8ea2fec35bc9f63279"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.20.4/hledger-web-1.20.4.tar.gz"
    sha256 "c4ba461165dd0513282bd0463c88effea2c29f2ca1bc8f7ed043d26572b9fa1a"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      (buildpath/"../stack.yaml").write <<~EOS
        resolver: nightly-2021-01-15
        compiler: ghc-#{Formula["ghc"].version}
        compiler-check: newer-minor
        packages:
        - hledger-#{version}
        - hledger-lib
        - hledger-ui
        - hledger-web
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
