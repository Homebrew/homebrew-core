class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.25/hledger-1.25.tar.gz"
  sha256 "b3188c5c22bdd20b58f9a3cb90dac637441120239bb00d17cf683ef4e6aebf36"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "044cc4a03f8e25fd6e15f3a6705e889eec8b6e14fc00c6d4880126c1c937f4fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92f7ee0f0813f3ac9a6009deb1884919f03c85dd62d8f06b47ef5b748bed06aa"
    sha256 cellar: :any_skip_relocation, monterey:       "fa0a494d77897f50d2e9272371e6fbfe3ab7e7ae8a8e49d92cf05f3277861755"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4f9a2bcfdd68ab8324bca034380bef936d6cc438c8daf10005ac63eec5b888c"
    sha256 cellar: :any_skip_relocation, catalina:       "bb5a1da8e70c10f7cc8ae7c6fc4a74199b14b59c41b18d5ff62867ff813ba1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbdfbd41f447ea068b77d7a5933de42cacc3fcd6315db93974fa2035fb5e774f"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.25/hledger-lib-1.25.tar.gz"
    sha256 "36c0dfe0f7647da17e74d3b52d91017aacd370198600b69e24212f3eefb46919"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.25/hledger-ui-1.25.tar.gz"
    sha256 "3d0c8024d5bca858860c41b8beb827a771d924a43f139d8059496fab52a84fe9"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.25/hledger-web-1.25.tar.gz"
    sha256 "0f390a73643de25396e5836c58786e209a025faeeb030dd5706591462117fe2d"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      (buildpath/"../stack.yaml").write <<~EOS
        resolver: lts-17.5
        compiler: ghc-#{Formula["ghc"].version}
        compiler-check: newer-minor
        packages:
        - hledger-#{version}
        - hledger-lib
        - hledger-ui
        - hledger-web
      EOS
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"

      man1.install Dir["hledger-*/*.1"]
      man5.install Dir["hledger-lib/*.5"]
      info.install Dir["hledger-*/*.info"]
    end
  end

  test do
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-web", "--test"
  end
end
