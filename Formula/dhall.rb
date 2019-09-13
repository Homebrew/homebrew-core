require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.26.0/dhall-1.26.0.tar.gz"
  sha256 "f2d0b4a1e274fbc5684922be49c43333b063880db57458e78de2bebd9afb68ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "49c7471dba6858ee7f901bcfc8c0f7439221e193d8513deb15d5f30d48b6fb9a" => :mojave
    sha256 "dd78ef8a9d94da6341cf8011499b02aa69318745b789079b4fd9839c3d07d90f" => :high_sierra
    sha256 "34e723d545ee00b684589542fa3769e6978aaf0183da7f1544da31383a816c7a" => :sierra
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
