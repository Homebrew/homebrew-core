class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.20.1/hledger-1.20.1.tar.gz"
  sha256 "799e9523cf4704e1ec90dbd3f856249405eaa6876edba954f07b78175db9c1a5"
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
    sha256 "ea0f380189028b5e6f1c41743de1692553d7752a001ea0f7e3ba715ba5d31d8e" => :catalina
    sha256 "db03cb4f2d644d7fd090898d039bb4ca5509ced2f116ecd1f2950bd077864098" => :mojave
    sha256 "31d4beba55f2acbe521b255b40e9751cba33065193be8be102381cfffcc98f62" => :high_sierra
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.20.1/hledger-lib-1.20.1.tar.gz"
    sha256 "c14bc3e1b704f657ece7741566330c44be1009ae66e14d98374aa513992e06ce"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.20.1/hledger-ui-1.20.1.tar.gz"
    sha256 "cc1b0b307e89d525b6393a5c07733f531cf13e69eb9235e3aef2c7fdbf0fa737"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.20.1/hledger-web-1.20.1.tar.gz"
    sha256 "14c93f228e28fc63122db7b2b6af70fb15a581f612165b6a9ee46ee6f6789b68"
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
