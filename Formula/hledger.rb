class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.30.tar.gz"
  sha256 "d2a946c47ed74b835fe90cdb3979fc26a266b9e4b7f6a01f7cf1e05910d752a5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "707a9a4a60836255b43d805524e91037d97832ecf94b9f69551f5a62b682dd8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2d0b1da989ba3d383f4b9960fffcfe9eb00516afb28311ca02471c847b8a61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "903adb4c92c4f2f8a13b50f4009359ca922078f6d8cc6494c333eeaf67d7cb42"
    sha256 cellar: :any_skip_relocation, ventura:        "2c592d4719ae2fceb4db92f5f0ec821fefd2473981bf090c2fc394f3e48c26af"
    sha256 cellar: :any_skip_relocation, monterey:       "5a29b43a0789f56b3209529dba0b3f5b746280515547bf44683b6606ccb83b81"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ee24fdabb7f6dd20574e8a8c127c3e5d8796a3a283df6b095f990d3195d6d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a1715dd99dd1981e0f68f05b5054b177f6c7266f93033bd032f104ba8f3e71"
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
