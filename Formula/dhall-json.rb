require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.6/dhall-json-1.0.6.tar.gz"
  sha256 "2264c7a631b1eb5d1c50f065f7fa4a9e9e76fec12317cd5faa0272cca6b5463b"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4a963e1953a61fde793cf0e5b3f6f73908d04791954afd0a7d86ebd857f830e" => :sierra
    sha256 "eddcc81830adc1e0a602f6ea1d8db8b8d1d3e2709140e53101ac70aa592df32a" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
