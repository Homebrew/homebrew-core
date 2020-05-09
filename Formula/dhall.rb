require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.32.0/dhall-1.32.0.tar.gz"
  sha256 "17a47b3b640da7334c76a4fee05e9c0aa6073ee6822fb97f6cb79851e002b2c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0d44f7299241c1e9e8997b66aa4547adacf40bc7e8ae1248eab21535dd7243c" => :catalina
    sha256 "1d7e51871e99b4294a90a8dd240cd5667b25d0d4ba439a29507ce38995a7fcb7" => :mojave
    sha256 "6ac2d5cca35d8243fb12977a7f5184594c36d7e16fcbd7fa6ab42ce5977251f1" => :high_sierra
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
