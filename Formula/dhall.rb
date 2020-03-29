require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.30.0/dhall-1.30.0.tar.gz"
  sha256 "f2be9599ddd88602c1577b0ca57849c9827c9e700e105102cecc17c56b7c4a81"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cf53e50cd33a995c71fe729f8eda3e8b8018be4322df8ccdd177ec86d6c8826" => :catalina
    sha256 "af3459e6845fc27e062a8c5f61cd914c598973c3d51df1e3da15dc82ef58f67e" => :mojave
    sha256 "f3d50a80445c28b3a1a748007ef2775b1d15b990057f2d11e7de8aa8bf6db847" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
