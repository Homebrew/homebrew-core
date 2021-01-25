class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.20.3/hledger-1.20.3.tar.gz"
  sha256 "a9638c12d1eb7325af057d225d77411d60b0f144d907012617b44ec5ee2dc4f3"
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
    sha256 "d6afd6441959d6dd3da9df2ccf5fffd0ba01a1945d42e20ee523c79888487bef" => :big_sur
    sha256 "5c7c5e170066f06f125bd9d26faf480c2cb1ac31135188e71c50194e9ea02ae6" => :catalina
    sha256 "99ccb9c6e74d3914f67af8df09a45256866763af58da4f347c1dc2baf7d224df" => :mojave
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.20.3/hledger-lib-1.20.3.tar.gz"
    sha256 "97a10c74fad977628e6ab9c3262db69e531598d5577f753a7933cf50e364a65e"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.20.3/hledger-ui-1.20.3.tar.gz"
    sha256 "81fe2b4480cc0291a90e0b4c7d36cf5174d859327c6a998d94ee18177bebe609"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.20.3/hledger-web-1.20.3.tar.gz"
    sha256 "0493a7fa977910abbd5c6076cd10ef03f4148408aac1226d6e9536832ea7e3b7"
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
