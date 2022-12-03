class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.28.tar.gz"
  sha256 "e2736f732d9f5cade993877b4524f06fbb3488142843c62653a0849180d2a34a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae3754888e79908af05f5d49ba2056f0cff2cfd2ba11d2bdffa3add0cbdaeea9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8cdec5b36120100254a460639eb3dcac63c54ae1b5070624b213ccbe3ab404d"
    sha256 cellar: :any_skip_relocation, ventura:        "865c618609b3b223be175f8d3297a487fd8b616900189f52408c9e37a867a37f"
    sha256 cellar: :any_skip_relocation, monterey:       "705fdc2a468dbbe0db8754d5eaf046c6cfe9a0ff46c9abd8b26146d52ec4fe8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d842d278f4e60a5ce14f0409844cb5f892374178b2dc7a1322d860cebbada14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960e2d8af466b27ac35cfa712bc65aee6d53791ef138838a30b20d6c19ce3982"
  end

  depends_on "ghc@9.2" => :build
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
