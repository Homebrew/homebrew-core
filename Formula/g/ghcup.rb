class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.50.1.tar.gz"
  sha256 "1719a8845454c3d1dc4dc83f5d7cc1f8df80b89c00c543860bc46acf15218301"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26e36207afda790bbf550d3d2085427034299eb9f45114e642fcde5ad36f6234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c13aad0c7e221b75d20cffb029bc5c8be7b6cf317900f5ca7014ca1e7f7487"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd2e01620a880f49cc79d81103aec79e8cf983aa5c6340a43ec8e87cee26c30b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb7d758f909de3b49429bda3784be2907943acbc44d65c5463c1c31a2eb6590b"
    sha256 cellar: :any_skip_relocation, ventura:       "8bab4e483b4676231880375bb519eb87cf0a88b803c4e7f7df3a810428964104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd852a02f121e84823a02bdb77fbad3d0f37ba81c1a414cccc660788f6d8c589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82ddd7e62f4d72c2ac0934cfc30d8987a159d801624541d766ed6541a55379c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

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
