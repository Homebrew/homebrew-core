require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.21.0/dhall-1.21.0.tar.gz"
  sha256 "9b22cc6f7694ef2f5d5d6fa66727044622b9905b2a9da0cdf376c75ad3b9df0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c751a56dc0fd6a65f80daa209ca094fdf926b5a74630d530bbf18ffbfad43267" => :mojave
    sha256 "993bd1c4176bb635fd7708749efe165f295ee34b5c78392cfaba53c6fb4d3c06" => :high_sierra
    sha256 "75a9ca2016e170522742afdb2ee5d19030afa9e5b7a3336c4bf5de0645198c9a" => :sierra
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
