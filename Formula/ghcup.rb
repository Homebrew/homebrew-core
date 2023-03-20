class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.19.2.tar.gz"
  sha256 "ceb9f0c244d8dc83e27379df8fda9b8753e18c67c0a8cce3b94b4e28f2d2b329"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13a7a02e53e4b1ce803efa68574d3c26c06e3bbc28a2118b706aba0f3bea3bc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f577e9464d37bb18dbb57cdb1e59383196d3caad2dfc94f9facbe9cb875caaa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d7b3dc3d40bbcc40381275e2d2abea35f2c57514ec2f8e3f98c99da8284a792"
    sha256 cellar: :any_skip_relocation, ventura:        "c48ee5fe5ccce4b9f26f602c5852bec4887dbba848ce9482fc2f25303489c8c0"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff70a0cf57fddfea58ef213b73ba6fa72f4721775afb6114d22e1de2ab4ffaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "2efd9b013e2eaf52d4b68ad7163ceb5019611a69090f715295f846946d4df7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93a3a4f1572d7cc33bbda385306bc4f70c9b91ff485c6f39c1980c62ef510532"
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
