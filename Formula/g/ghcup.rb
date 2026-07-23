class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.6.2.tar.gz"
  sha256 "a8b4657d235bb14fb8c4ed33cc3059297fbbb2dd98e239f4629c1ed1632041ed"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "41ac1d7c50f5cc48c7f797cfa10ac7c3ba815b86ade6fb317f2bea1f1e00ce6d"
    sha256 cellar: :any, arm64_sequoia: "98ad00690c1f8d6ea6e7e8f859fb4f6d997b25eed1391f18d74a6ac36f456311"
    sha256 cellar: :any, arm64_sonoma:  "5bb1fe22532e7731ab40a00e98a5558df4f96ede37e6f6a7d26db8a0383fafd8"
    sha256 cellar: :any, sonoma:        "cdf9bbd2fc71898a50b17e1e92bcc83eda6ecdfb1958da55a0895140afbfb038"
    sha256 cellar: :any, arm64_linux:   "089fec38ff35dfc54fac87c44bfc3f1b4a863bca6dd1245ad67a8a0b567ac637"
    sha256 cellar: :any, x86_64_linux:  "df6f982eac74479a58ec6a3ed66b6d01232692b99655688b60d4f20df4854223"
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
    # Workaround to build with GHC 9.14 until serialise > 0.2.6.1 and dhall > 1.42.3 are released
    args = ["--allow-newer=base,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args

    bash_completion.install "scripts/shell-completions/bash" => "ghcup"
    fish_completion.install "scripts/shell-completions/fish" => "ghcup.fish"
    zsh_completion.install "scripts/shell-completions/zsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}/ghcup list")
    assert_match version.to_s, shell_output("#{bin}/ghcup --version")
  end
end
