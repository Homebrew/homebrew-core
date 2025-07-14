class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.50.2.tar.gz"
  sha256 "ba2a2ef799fa7810970e09b19a7fdd7b2360ddd64d8e9b0624ab640cca627b89"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e247f6decbd4256535c586a0d6146ac65e53efacce5dc330e115be4c98dd513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed53b589d43d4651f51d4c8cbf59910dc9dd1babeef7101ad54daf8f9e728ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9b74e79970c00cd845b676d54299df10b4cca34e44fab44d3d8d1e16b9ab263"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5b4cd2f5dfa18fb80c96a0dfeb4c20c519e4a1cc4d25d35844c46dbdc323c59"
    sha256 cellar: :any_skip_relocation, ventura:       "d7acf0c16461d16b43e2d3ac389d1a59e07c9342b21997c77d357397324f3de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e3d38dd1fdefb2c67ed6ca6da1dad745b94cb9895cfa76bcf97a5e5fca459d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864261ae983d405424f6177e75614dca8fd661be23aef0da4fda28b08767c20d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "bzip2"
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
    assert_match version.to_s, shell_output("#{bin}/ghcup --version")
  end
end
