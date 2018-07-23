require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.2/dhall-json-1.2.2.tar.gz"
  sha256 "2d5527c5ef5ce92d75edabe29c9a6086a8ef108e79c0f73c1331b1513ab86a8f"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc5c315c6a1716cb3f798f0038afc6f3bd613128d5e0e578b5c497f96f3bc614" => :high_sierra
    sha256 "804a9f66e5658fd2a80a8b6c4a0ca15dd668c10976b4eb42a6bf31ddba9c19b8" => :sierra
    sha256 "34de083f3278f32175ddc4a1638133051dff68340f1d44cff3eb574d2d517ade" => :el_capitan
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
