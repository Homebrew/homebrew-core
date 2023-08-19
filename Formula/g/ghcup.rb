class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.19.4.tar.gz"
  sha256 "72f9014c3f723365c04422bc2ff9ac1b1c60cd6f25792fa289ea2078b407aab5"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01e0db2f2f585dd19dfac9400e986de8eae688544c557be00bb4d30c07a9b62d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1914b298d667f189282e39bc53ed49e23ff12a4d6b5fb31d356e9e472a91ead0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2df331f7229cebb54b8dea7657ab6cd5e44e3b69e15869ed73a4311bb40ae78"
    sha256 cellar: :any_skip_relocation, ventura:        "ed1d0a6e89fe7b658a933c5c4838317f9c799d3a26933da0dfe52237d29eb873"
    sha256 cellar: :any_skip_relocation, monterey:       "c9e7e7698b8633d1f850c8eae997448147e4774b320c777836e8a63d8ebf3bf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecb367c841dedc9d1c201b0be070adbc5aaa1ae3b8e72dac0ae1f8ff528a0ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1941de81ca6ae837ede20ed4344d85a34a4ed3188ca3b20cc7830878fbc56f16"
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
    assert_match version.to_s, shell_output("#{bin}/ghcup --version")
  end
end
