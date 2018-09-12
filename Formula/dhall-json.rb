require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.3/dhall-json-1.2.3.tar.gz"
  sha256 "83cb1e27f937c50ba6852eeb55ed3f06af8db9b73716bfa8c1326699482ffcda"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bab7d01fcbe420e80d7a5f430912a0ac2e758b94533df421cfcb672f7b9388cb" => :mojave
    sha256 "7eebce96f35a991539034c2939dbffe8d36606b2b134eb2a164efb01956bfe7a" => :high_sierra
    sha256 "9b24081f5cb6d98467ef9ba670336166dc0f2a68733667147b08fb929d7c0bb3" => :sierra
    sha256 "46a7cf5d4660faefe3cd940ca9eab0e445b97a70b8a4a3d4d8eef19521995f4e" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
