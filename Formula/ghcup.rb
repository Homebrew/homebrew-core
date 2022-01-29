class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://gitlab.haskell.org/haskell/ghcup-hs/-/archive/v0.1.17.4/ghcup-hs-v0.1.17.4.tar.bz2"
  sha256 "9973a42397bcdecfaf5f5d8251b4513422b80e901b2f2e77b80b0ad28d19f406"
  license "LGPL-3.0-only"
  revision 1
  head "https://gitlab.haskell.org/haskell/ghcup-hs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99117e7608d26d9ba771db60e77e2610c9862cb7779f8fbe693031dda05650fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0824a2acabc5a93546dd58718309456acc8ee0286061ca8a5da09744a610b7e7"
    sha256 cellar: :any_skip_relocation, monterey:       "9114a8741d39f23842a8e60057a9c11092060d81073676a8173aceb2cd467c78"
    sha256 cellar: :any_skip_relocation, big_sur:        "97268b8bb95a7e7d69a385f2662705689adf6ebb95dd4682c5bf656a22bc2ca0"
    sha256 cellar: :any_skip_relocation, catalina:       "0511d60c226d31f471093b1f697ed12e0f0b981bc35a3ce616fcec41069da7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c13ef4bb20beba2b590cbd05718adc306720342d768fcd29aa4e31c32541ddb1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Disable self-upgrade functionality. Backported from:
  # https://gitlab.haskell.org/haskell/ghcup-hs/-/commit/b245c11b1d77236c75c29fb094bbb9cfd70eed48
  # Remove at next release.
  patch do
    url "https://gitlab.haskell.org/haskell/ghcup-hs/-/snippets/3838/raw/main/0001-Allow-to-disable-self-upgrade-functionality-wrt-305.patch"
    sha256 "a20152dead868cf1f35f9c0a3cb2fca30bb4ef09c4543764c1f1dc71a8ba47f7"
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
