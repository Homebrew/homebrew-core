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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e6a0cc1037d609427bd3e2121d2dfb07328d31bebfb6b8b42c9b703a9882e70e"
    sha256 cellar: :any,                 arm64_sequoia: "1761d3fd2610c48ab9d2a048eb8f8a25a1c7def62ae960812f17feec94c1444b"
    sha256 cellar: :any,                 arm64_sonoma:  "c58916768b45402fe48af59be753186db8cd56e9f28ccfe9817ab9ffc98fbf48"
    sha256 cellar: :any,                 arm64_ventura: "2cce48ab0a56115ea853ac0f383f59fc2d419a6c9e414b5af8aa02fabb505fbf"
    sha256 cellar: :any,                 sonoma:        "6e4b55a318b5e9dca9cec9d036dd24d3768ecbc1b8da4fa2ddbf0948cefc6bf8"
    sha256 cellar: :any,                 ventura:       "186dd4888ad499c08142075d6e5da272c28bd376fba7ef89a01ac5d27803e3b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51afd964e6e0027e176f2a1b429d5e8d87b93a833be9b3382fd8435bbef1b905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaca952bf9b6b634b37333219d910b95761c323e386c709e7c2ab1779ad94160"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
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
