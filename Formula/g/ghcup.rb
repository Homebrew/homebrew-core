class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.30.0.tar.gz"
  sha256 "89d158023f634f079ac6a306bb87d208445384a725d47b432f6858c8876cbef6"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "647806a77229da671021ab4c6d431206f2919df839e23cf968e171b3313a5266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a094b83eace9d934e83c5c7ec40eb554dc4997704cce8ac76e0d3eee417b466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecf11f3303f741710f9b371a40f721ee54da0c531a3ea3aade4abe4994fb5b45"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2d2a358c8873e075b1a8cda6189589e1122640db278aac9a8aa7df9f9fed8b3"
    sha256 cellar: :any_skip_relocation, ventura:        "bc3ad734f978a1ef0c72867606e147b81232a293191cbe80386a2cf28ea35113"
    sha256 cellar: :any_skip_relocation, monterey:       "64861f0ffa4e246865adbade896adf4d2be20c56c1054b601bb4a1486eab3318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e6e87045f4b758ace03abd50ff81152094d8608ec1d4e1aff8283e69d555800"
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
