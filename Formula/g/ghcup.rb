class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.22.0.tar.gz"
  sha256 "73e1644731ebe9b4782c5dc080ce2b2c3022449c92bcec9cda15fc06300568df"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42ade76db70a776050120860ff93699c3aea29033b1f409b1bcfd3d4357515d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb6fcf558e4075c0f118218b0370b5c8c25cd6454098205c9b30a32b274c1284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ffa68e887981f4a1dd857a8c049ee8660ea42ab01c80c7dec345206c1e705b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9241ef68c71ad68977dc3816f8b7c00c09fc718e4e831cb4a7cf478b2c1d271d"
    sha256 cellar: :any_skip_relocation, ventura:        "6fc49198466290116e20dcf5fa18a3c769b7a596a25e4cbe3f24ecbfe7991013"
    sha256 cellar: :any_skip_relocation, monterey:       "17892b43dabe9cd9264e48541de4e1e2239786891bccae722ab52838ef6580ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "816ed6721a32b7a8a3fe14dca949cf6383a54544ef9bcf5dab4cd0e2f32867ba"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build # ghc 9.6 support issue, https://github.com/haskell/ghcup-hs/issues/979

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
