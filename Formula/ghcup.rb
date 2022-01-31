class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.17.4/ghcup-hs-v0.1.17.4.tar.bz2"
  sha256 "9973a42397bcdecfaf5f5d8251b4513422b80e901b2f2e77b80b0ad28d19f406"
  license "LGPL-3.0-only"
  revision 1
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553aee233e4617d6140fe218d772e470c66ef12b527b3cf709a42b809716bf0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66b07f315f6644bdb133b8e19d1a33cc9ce4974eb554259f86b984249d9a7960"
    sha256 cellar: :any_skip_relocation, monterey:       "8288b59b86ab250e920405bd54f3a6fc025c5c9d6526227b4310e454593dea89"
    sha256 cellar: :any_skip_relocation, big_sur:        "8157ac923242679a8e4e40edc15afe925c085b94d27d1e6871e18993f2aa96bc"
    sha256 cellar: :any_skip_relocation, catalina:       "cebe472e27f95cc3789f74d2884ad48cbb488c798d28e30def65429a93cb5627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac2cafcedefbde7e47aa147b81ffa0336b0e397e471ab62d5deee5480d06c87"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Disable self-upgrade functionality. Backported from:
  # https://gitlab.haskell.org/haskell/ghcup-hs/-/commit/b245c11b1d77236c75c29fb094bbb9cfd70eed48
  # Remove at next release.
  patch do
    url "https://gitlab.haskell.org/haskell/ghcup-hs/-/snippets/3838/raw/main/0001-Allow-to-disable-self-upgrade-functionality-wrt-305.patch"
    sha256 "a20152dead868cf1f35f9c0a3cb2fca30bb4ef09c4543764c1f1dc71a8ba47f7"
  end

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
