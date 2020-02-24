require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.1/dhall-json-1.6.1.tar.gz"
  sha256 "3ce9b0a9d3a946beb021bb42589426ceb4c44cf5f104e5bdf120659ccb5109c9"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfc7e2ce2ae83fb5093eff83f15e19d74a73915455fb328c0af9fef1c4095db8" => :catalina
    sha256 "2fd72d8f6a7edd4162a2058c6cadf3368af1cc304d0cdf2f23c2538f23219b8a" => :mojave
    sha256 "28d8fa30f1ecc0087c27994d6a6d28fa08e72bf48db36669ec484354a1d1d221" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
