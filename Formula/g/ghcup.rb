class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.5.0.tar.gz"
  sha256 "e6fbf2a58f9e0ba64fd5565ae8b25eaf3ac8f2f745fea6c295661d2c94f78e75"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7be847690dafdbdd7f359ebc8dcfd1d618e20817df5d07c1e025d4402337f1c0"
    sha256 cellar: :any,                 arm64_sequoia: "f21a07d76be73053df13e1472e82137bbb6e58d6a6cb45566bfd67d6bc1e7fff"
    sha256 cellar: :any,                 arm64_sonoma:  "6bd39fbf526061c564ef066ec4bfd9ab1ed5869a260b84f6e73a489f1675eb44"
    sha256 cellar: :any,                 sonoma:        "e7c6b45a068c53aa82c79f629f5d97138a0ecaa79ddb33f8438db034ab836f04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ac6ac50d4b833dbb5c08a9b06872bea607a554b244fa0b365f170f09494525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0318897592726c2d2f150edc486a98ecc3a02e359cb5b0fbcc67f4454389691a"
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
