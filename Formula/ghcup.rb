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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1ff11acfd5d4bfc8d5050685309d786ae45d872f6f2133413111386f0572f6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38cc23c277ff1380efe541724efd8948b2d11f6975894308701c68bc6dd0a192"
    sha256 cellar: :any_skip_relocation, monterey:       "a596b6c3b68987bc2f9bf04aaa2b81d98d1f1e10ad15d6412ac20cb96037dda2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d81ecd860d580ae0ce731e7be23dfcfd5d3db9e224a6b7bc3d32617b407c060"
    sha256 cellar: :any_skip_relocation, catalina:       "dc87aabc5b8f6904f040fa2b6d67f22e3603e7108eb5f579ca18514c569a5987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe62c7db994800ae99cfedd15e6ec30b60950b7085b63e43ac1e012ffc9fb028"
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
