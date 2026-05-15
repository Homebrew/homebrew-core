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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "811917322d97837106d12170b91163432ae7c85aa638d1d96f029f9dec0cbb0e"
    sha256 cellar: :any,                 arm64_sequoia: "ec991d6ddea9fbcb3c419543dfccaab1bb6d1d0902ba195f1e42f1a37241ee0a"
    sha256 cellar: :any,                 arm64_sonoma:  "78dc9e2eaaf35e85f6d5a11a3bf1ea93bdc7288f614bb81eeafb162942eeebbb"
    sha256 cellar: :any,                 sonoma:        "198abd421c4cc7e9aaa9274920e01306f42d98946ac6c87266a810048eb542db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "515f3d49492075a8d3d9c54442061f468485701be58045c3e2f19da055e10a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cf4e303d7c63d8dc7094cb14558d753ca914f5b71515b26dae21a4c20004df3"
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
