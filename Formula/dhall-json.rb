require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.12/dhall-json-1.0.12.tar.gz"
  sha256 "4b493f17914f659ce42f656104b9ffbd7847f8d19455c447c8af33779cd39a9c"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7b9dbba7630e06988da57fe5c4ad9a2670b518b180bce2415aa86c5dd42ad51" => :high_sierra
    sha256 "58a0023ff311bc738ea7213fa8bb4a81215e61dcd28d215c204426dff9381ad6" => :sierra
    sha256 "9104547362cd3e4fc62fb2935e485c5a21138f5b200c1abe87d41fdb8938c08c" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
