class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.1.40.0.tar.gz"
  sha256 "80c4c1152ebc35372b987ffa5b46fedc4e940eaf581e6ab11d93d0892bd16fe4"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611473f27d6f07a103370c58f1572f47e6ee7c55e3a75d73ff8bbe466d5a6b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2929bb6239b31767d31a72663cc5926ca38cb4e02a6af97f01931054a63376f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52895db51721d777c0979c6ba63fad6c74108255957f46001ec37c91028fedf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "49b26a9e21b76d40063cf64302d100b5c6b7a628defe349c65051bfda8c5d0e6"
    sha256 cellar: :any_skip_relocation, ventura:       "85b6b1c21f44e5873cbc00bb7cf8ac092770945db5b9709ccf41f6ac56998064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0819ba00818f8cca4e4452b4dbd40adc1d7a04f1b5932cb2e5649df4921cf17"
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
