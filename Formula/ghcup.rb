class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  #
  # TODO: Try to switch `ghc@9.2` to `ghc` when ghcup.cabal allows Cabal>=3.8
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.19.2.tar.gz"
  sha256 "47c85ca6ced22f62831c9f14b7ff5feec3d6d5ba24af089ac223ed1c8d0fe47d"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad2f9e2f9442c0e2445a140e52516b93fa09ab271f27c9328024d72b84ad8d03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8fd25d92e26b13e31a78cd0185258321cfa381375ed0e29bb16c023d7d1763d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6c374ee90254045c3df618268852ed7182d38a404a36656d8c91a3176007331"
    sha256 cellar: :any_skip_relocation, ventura:        "8cae0d1d4a20e8fa9a6dba80bfd44fcfa56417fd4dc91ef46c792ff8f86ae166"
    sha256 cellar: :any_skip_relocation, monterey:       "e5739de269fbe1ff0b03ae564fef3714b030caca20fcd5f500132e308fdca885"
    sha256 cellar: :any_skip_relocation, big_sur:        "ace684548a140c8db60e51e40e750dccc711e73ca2976b919b46eabeeb83097e"
    sha256 cellar: :any_skip_relocation, catalina:       "39d01f386acc5221527cbbc3509030a161049b252bf8b62507b00fb87e93805a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "970569f896725c826a38193e32fe89cb4521eedcf4a8f1e4f704d98f3809811b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
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
