require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.11/bench-1.0.11.tar.gz"
  sha256 "a84e6faa55e62b7cb9f7d28a1d1828298f1c37b24c2a16da86954a35534a3b97"

  bottle do
    cellar :any_skip_relocation
    sha256 "5adeec4ab1578d99f5c8d3be229cb3b645e5b3358f8df64e7e330e3e6e390ba7" => :high_sierra
    sha256 "a867ca7b691be470cd57bd73c16903868d085cdba231a1cf43a13a3f57605af7" => :sierra
    sha256 "853fb191dc850fbbdff61a3045a235b249651d5bb4377c075fbfc8ef5ea3fa72" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match /time\s+[0-9.]+/, shell_output("#{bin}/bench pwd")
  end
end
