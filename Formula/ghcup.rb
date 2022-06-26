class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.17.8/ghcup-hs-v0.1.17.8.tar.bz2"
  sha256 "789cd286b6a7f2bf43f84079888dd3771a9944cca72ca4bfc971689936d0ae36"
  license "LGPL-3.0-only"
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56a4c8ad7ce769ab9ea73cafa0a467f756b8cba1d092c87650976b3d913e2a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4385416171b1c06317ff3fcfb948668f0eadb65fef36231c6bacf3e3d3cffa0f"
    sha256 cellar: :any_skip_relocation, monterey:       "aa6a55b4e8ecc1d467513a935de43073a4ac52531825e6dfc6239483e9226eab"
    sha256 cellar: :any_skip_relocation, big_sur:        "154d6fb19190c3be91c0354375cfddcae094b5730838a96dc0ef6d99c4ce2bd3"
    sha256 cellar: :any_skip_relocation, catalina:       "daeaa2f93032f60bcf321545982f9c3ddfbc87df5584782ada8b6d76be75c988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180d240de86e7a58be172432643de93e9508a9843f58ee544e6ee15e18d8745e"
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
