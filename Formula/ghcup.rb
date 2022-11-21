class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.18.0/ghcup-hs-v0.1.18.0.tar.bz2"
  sha256 "fac7e5fd0ec6d95c3d2daa56b4d77ec8daa37b179b43e62c528d90053b01aeb9"
  license "LGPL-3.0-only"
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8fd25d92e26b13e31a78cd0185258321cfa381375ed0e29bb16c023d7d1763d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6c374ee90254045c3df618268852ed7182d38a404a36656d8c91a3176007331"
    sha256 cellar: :any_skip_relocation, ventura:        "8cae0d1d4a20e8fa9a6dba80bfd44fcfa56417fd4dc91ef46c792ff8f86ae166"
    sha256 cellar: :any_skip_relocation, monterey:       "e5739de269fbe1ff0b03ae564fef3714b030caca20fcd5f500132e308fdca885"
    sha256 cellar: :any_skip_relocation, big_sur:        "ace684548a140c8db60e51e40e750dccc711e73ca2976b919b46eabeeb83097e"
    sha256 cellar: :any_skip_relocation, catalina:       "39d01f386acc5221527cbbc3509030a161049b252bf8b62507b00fb87e93805a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "970569f896725c826a38193e32fe89cb4521eedcf4a8f1e4f704d98f3809811b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # upstream mr: https://gitlab.haskell.org/haskell/ghcup-hs/-/merge_requests/277
  patch do
    url "https://gitlab.haskell.org/fishtreesugar/ghcup-hs/-/commit/22f0081303b14ea1da10e6ec5020a41dab591668.diff"
    sha256 "ae513910d39f5d6b3d00de5d5f4da1420263c581168dabd221f2fe4f941c7c65"
  end

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
