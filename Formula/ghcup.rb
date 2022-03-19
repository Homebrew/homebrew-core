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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4fcc54dc7d23ed80973da5997431b04ace3e2d044cae1e2174aecb9f3d21e61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a63fd1f088270bef36256451d0d3f945ea21f158778dac218fdd871ceb381470"
    sha256 cellar: :any_skip_relocation, monterey:       "98a146945812cece33f346a41d7b0a4cff823a7881ce5bd57dbd8790460a640f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a00640dfe7203f6be6604e159d58956b400767206ad16d9ea7f83211943e06ef"
    sha256 cellar: :any_skip_relocation, catalina:       "d3c872e80c54ffd4c807fbe76c666aba45e3c967a4a9ba21b92bb8e11d89a0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f099881f02d6dae4f756724707da0f7d0afb8f14387af0f74237ced04b415903"
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
