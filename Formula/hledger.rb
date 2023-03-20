class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.29.1.tar.gz"
  sha256 "3dab4557d0c25ff05ef62f33e5f13b8c13f4060c370530997a379b3096ecdb67"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17755b3e57a9ad5620f0133c7435f71398d4ee343582e9cecf41d813cf7bc213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b76b47a390696429b59016ca872f6c14b236d6117724a7c0968ee8a36e11c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "02186fbedcefef4b3d8850874212c580b4e8653c37afe3cecd878e2287d4f307"
    sha256 cellar: :any_skip_relocation, monterey:       "612bdfc24f618a7e2a064c892d34409a07131f71c95c30e93dccfd1da9bba66b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b145dda43d4ed9c937d1a0b14a470dae9d2dba6dd360fa266532808c36803473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba763d9366811f02b5dc0e73c2a8d651cab0dd9c71e7a0e782e02bc56c8cd0a3"
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
