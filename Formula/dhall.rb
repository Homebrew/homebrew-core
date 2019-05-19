require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.23.0/dhall-1.23.0.tar.gz"
  sha256 "eda7b9d1baad8214f83aaf7e7ce5e374c32a62f58ca69734024fb3f254bc9d1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2ea6d6589d2f4b5085d5ba7c2c690d49887a635f9913f22591e5681d79069f5" => :mojave
    sha256 "04c1e0b7442137b8d2882338d6ae4810bc2df4cc4060afc33240eb293fac4ea1" => :high_sierra
    sha256 "bd7bfd47f2ea46b0dd54204a1e24f8b50af134ea51d57c6c7a7da2974ad8c04a" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
