class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.17.6/ghcup-hs-v0.1.17.6.tar.bz2"
  sha256 "b87e9ec2c4997e35118c952747cb14341d6979719f097a1c40616dce4d522329"
  license "LGPL-3.0-only"
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6103e1b78c9340fdc260e4372123ad01476529670084dcec65bef1485ea26502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4e96484c091e49d3bc4057bfd923d052aeeed7dcbea7b82f58e51fbb867f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "1832948d42d37025906e83753c7a7211d7ddf41d560eaa5c63be83858d2f4a6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e21f60e37bbc76b6044960a881df940d4ae9368cc81429f23a1591e33402669"
    sha256 cellar: :any_skip_relocation, catalina:       "b29e6f6ebe9045ed9f049b37306f315a96b149f0fb23d1e104221d2520a7954c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b733b6b1467810a314970d8f5da0223e31763181b10833b7d7e83e9a94fcab0b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # `+disable-upgrade` disables the self-upgrade feature.
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+disable-upgrade"

    bash_completion.install "scripts/shell-completions/bash" => "ghcup"
    fish_completion.install "scripts/shell-completions/fish" => "ghcup.fish"
    zsh_completion.install "scripts/shell-completions/zsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}/ghcup list")
  end
end
