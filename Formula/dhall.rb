require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.24.0/dhall-1.24.0.tar.gz"
  sha256 "67ff6ff2bcd3c3fed0a598f8038f62a18676a419f7f7773a07804a5cc89404d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "750acadb9fb309b8e73458418a9797da3ca979d5bbd7ef4f35fc051b0222b915" => :mojave
    sha256 "b7e1d9543e2c162e7964116f79cc78722070c9dfd9838e2aa3d63b0e9dde96ac" => :high_sierra
    sha256 "fef210fdc41bb8b65036388b87c1e1166ea15ddd0967396a5105e02b69277f99" => :sierra
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
