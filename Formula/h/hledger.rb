class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.50.3.tar.gz"
  sha256 "fcc6e26e1dd53bf747723c2d54f53fbbc8d5ab78a1393b21948616c7615a5703"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5a8e267d01f4a511cb6018341b78371f37cc67098274fb014992fd386b4b1e41"
    sha256 cellar: :any,                 arm64_sequoia: "8e9c08d2e0f72d92a6d0fc2254d3cc4d9a6b99cb4603e192f5d16a0293820ddb"
    sha256 cellar: :any,                 arm64_sonoma:  "21f374782166e3ac50a148c3bf43398d503bf2207d34fb4718283237a16ef7db"
    sha256 cellar: :any,                 sonoma:        "837bc34c4943b2c8b208feef7c9828b5634a5712a39c20551282760a34879d8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d48fcadfa35ab1c701eff1ae95e3c3cb314459811f1a049883db7868fcacdeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c00be0968a21e308a5df650b40ae7eb629a4337dcad34cfc942a475f28fea2c4"
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
