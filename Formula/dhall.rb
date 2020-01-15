require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.29.0/dhall-1.29.0.tar.gz"
  sha256 "c73e59717ff15707c77f3ff582f5adf68fc7abc68dbf70aa77ce65333637e7f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "28de82258d1e1b82728af51fe072261a4b29fe3cd543258afe7a24a3321c770d" => :catalina
    sha256 "f8d354fd0cd7329671a563f343824d87125205a57f9119d3fefe0da9b2e08f17" => :mojave
    sha256 "e420e994a3954fd9d21c727961f8d3b5d1d2039a3a6e4ee71d17189827e2c995" => :high_sierra
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
