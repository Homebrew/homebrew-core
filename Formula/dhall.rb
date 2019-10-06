require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.26.1/dhall-1.26.1.tar.gz"
  sha256 "f6269eb7f986e600ec5252a0b793b0a0a60eb24db28ff9c3e5f2adb006b51ebc"

  bottle do
    cellar :any_skip_relocation
    sha256 "82dc376df2f09db461ca77ed4511244b0d19faef3b88b3b3e71a528adbccf08d" => :mojave
    sha256 "d8a2df2811305c32a9568f62b6b9348b0f1c9a7ada4f295e5453aeb29db01664" => :high_sierra
    sha256 "5050e33096e2c1c3727a9938fd774b8d3d3fe7d52348cf5576a6f38ec7347187" => :sierra
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
