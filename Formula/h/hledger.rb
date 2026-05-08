class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.52.1.tar.gz"
  sha256 "242ba652cb76b2ca5cab1ba7588d0c99c8b7ebb329d76785f1851f2d5e9e95f6"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "main"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3418bbb9913aa3091ac52ec529dd841fb710165d79c142aa6f69c416ba186f5d"
    sha256 cellar: :any,                 arm64_sequoia: "62dc5190d88662b6bb4b5c1f8215ba2278fe7997484bd0d47e694c4d4d1b25ca"
    sha256 cellar: :any,                 arm64_sonoma:  "4382f3a7b41c3bcbb5cf62cb508f271008ea2e1aa6129d784de26cf67d42e2bf"
    sha256 cellar: :any,                 sonoma:        "e87a9220f1832041012e310d8f5ca342c25721767d3b82a3fa629a6253e83830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4947e53576045a611dafdb8867fa59f93e4f67b576e6e4d34bdbd6d8828a27f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17ce67ab1b754b86b6c07671793094d6dc89ff9d01d62bba29e6c7560fa38834"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
