require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.27.0/dhall-1.27.0.tar.gz"
  sha256 "e189fecd9ea22153252609a4d7c5cc4d61f2c36326b53758b61e5a851e701712"

  bottle do
    cellar :any_skip_relocation
    sha256 "78bdb049f746971df0fa86089458a944d8aac5c92f15c901c9d951c46d45e679" => :catalina
    sha256 "66a5dd7efb710606a6332fb932befb28d49bf157403a485ed04c1e1628217c22" => :mojave
    sha256 "5e4741e8dd0ecaf9a762e7316eed2f6ae86db7c9fb8da1e36977d07d23f34cb9" => :high_sierra
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
