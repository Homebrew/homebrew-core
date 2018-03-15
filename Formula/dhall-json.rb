require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.10/dhall-json-1.0.10.tar.gz"
  sha256 "f872132fdee24ba845a81b32ae5897f0e29662c8de3aaa7839148832202c0b7f"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7b9dbba7630e06988da57fe5c4ad9a2670b518b180bce2415aa86c5dd42ad51" => :high_sierra
    sha256 "58a0023ff311bc738ea7213fa8bb4a81215e61dcd28d215c204426dff9381ad6" => :sierra
    sha256 "9104547362cd3e4fc62fb2935e485c5a21138f5b200c1abe87d41fdb8938c08c" => :el_capitan
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
