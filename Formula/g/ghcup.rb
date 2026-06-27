class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.6.2.tar.gz"
  sha256 "a8b4657d235bb14fb8c4ed33cc3059297fbbb2dd98e239f4629c1ed1632041ed"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9327efca408425c3dc66ee2dcfa158ea15c7f44982a5c07ab06103eaf67a2fdb"
    sha256 cellar: :any, arm64_sequoia: "afa78521778bbe8c86685bbb5e778a42e4b077ad48ce8ef62d8de19a5c1fa936"
    sha256 cellar: :any, arm64_sonoma:  "ff1bab0922639100dc171a2db067787779ca87ac18f556e013fed82fe799b90f"
    sha256 cellar: :any, sonoma:        "8775022f9037d4290f6b9801ddc64798ed25d98a71bee33bbafea6351a7a7585"
    sha256 cellar: :any, arm64_linux:   "e2533fbbf02b03241aa9f9a10d554f280330100b8cee70062aca1047b8765e36"
    sha256 cellar: :any, x86_64_linux:  "8387bae857f457db7fa3ba137395a5e6bf385cd2453ed4198e46d8f33c253708"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    # `+disable-upgrade` disables the self-upgrade feature.
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "--flags=+disable-upgrade"

    bash_completion.install "scripts/shell-completions/bash" => "ghcup"
    fish_completion.install "scripts/shell-completions/fish" => "ghcup.fish"
    zsh_completion.install "scripts/shell-completions/zsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}/ghcup list")
    assert_match version.to_s, shell_output("#{bin}/ghcup --version")
  end
end
