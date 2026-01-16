class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.51.2.tar.gz"
  sha256 "0523c5b0a2014459364a997ad74aa8cad1a78d847c3ede6232d19636207aee48"
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
    sha256 cellar: :any,                 arm64_tahoe:   "25b1afe20cd127c6254ac425978c081aed7a3f82d5e0ffa59d8429a77bef18e2"
    sha256 cellar: :any,                 arm64_sequoia: "eb1f29d270f5f4911cac26bbbce2945f345b72746ba28896c0859e910aabdfdb"
    sha256 cellar: :any,                 arm64_sonoma:  "8c69ef24ba81563121c82e59f50ba8ba43a0cc6a2feca19584e822790ced14bb"
    sha256 cellar: :any,                 sonoma:        "5fbaa764c63753f15bc9d2187627480da5291ece0774a3733d57ad0810b286a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f35009c7cf2cd47b059cdabfb1690347d77205ffeddf895e741fd7359ac2eef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d97cca9eb369c60dfdf2570b28c35a083b66dd8cc0c1bbb22dc92f7fa89f37"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
