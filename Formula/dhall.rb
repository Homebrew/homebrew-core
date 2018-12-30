require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.20.0/dhall-1.20.0.tar.gz"
  sha256 "662862e65e73de18c01001e0ab43af155d111631ad12d14d89ec37d1397ccf43"

  bottle do
    cellar :any_skip_relocation
    sha256 "1df23a4a22b87e8c9ad7672cd3b0726d6ea4c4f949a5ac08bb0a07c8dfa1f45f" => :mojave
    sha256 "4136059711c99078328454e09e96de7f23384893880c20db3e9ecfc5b4b9e657" => :high_sierra
    sha256 "4f49604823c40e758442b965c57f8d656c2fa442857d9e698196b2d3165edd9f" => :sierra
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
