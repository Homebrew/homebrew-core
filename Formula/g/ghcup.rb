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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "265c89bb4b86c2ccb2dddf505b3f42aac8d74966a7c33c0fa02df638696aa107"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb5654fc951a2c3b7ee3b230b3e0897e72ff159bad98aa8cb47e2246f0a54b2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60694c05d2030567b88d72cb3c277ba56c440f4168750be4eef63283a167929b"
    sha256 cellar: :any_skip_relocation, sonoma:         "84f74f0e21b9013514d1684019e5fa54c676e7c52165cad4eb7e6aab70ec16f9"
    sha256 cellar: :any_skip_relocation, ventura:        "99e059dfa9fdec6e023b50d3556b818d8d6fc65b1a25419d8e86cd9ce4a92cb8"
    sha256 cellar: :any_skip_relocation, monterey:       "2b9745f11343dc686d5bdf5806274f13bd27a952be67b4d8c0d8abd8ba21032f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b715d10279d9d6cb7d03935b6de7a6d9dc74d56357244cee04360ac4e22d6e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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
