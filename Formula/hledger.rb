class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.27.1.tar.gz"
  sha256 "218f6005b7b30308cc43523dc7b61c818bb649abc217a6c8803e8f82b408d239"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906ea44bb34f510b224317a067b53ff5db67afb9ba4e0d8578fbc82a41d424c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "068c84f283d7b683dd563848d4a6bf92c5e1f899ae4901df948c55494eff524b"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c0a9ad57123a87c93b26422cef60a1a8a953a4f0ab3838228c0749e7f3192d"
    sha256 cellar: :any_skip_relocation, monterey:       "88b34ce63d0c827d2ce9a5097cc933b8caa3082b39233c417cf58d7b45e25ae8"
    sha256 cellar: :any_skip_relocation, big_sur:        "544662b7a25563d2ba0c50faafc79a836ca40bd270e42988b6ef1e61f1801090"
    sha256 cellar: :any_skip_relocation, catalina:       "615562ffa5f64553db5d909611fadd1856d20b5a36666814be9cf656ace9abd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ec70d8ea2b11ff1621ac6e208d2e1b4f56b10561e087c9e4ceb7df9367f23d"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger*/*.1"]
    info.install Dir["hledger*/*.info"]
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end
