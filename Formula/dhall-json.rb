require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.7/dhall-json-1.2.7.tar.gz"
  sha256 "11fca18fceacbff9f3b3ca86012f45b82fe9d52d2e689cfec434841a6e63e3f1"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be720f359d2d4a410710e680f92b00ee1dc27b73ba57325d22749d0655f6db4c" => :mojave
    sha256 "e2d137cae281e8dfe163314c0bf68f9481458808b233287fbe7567b92122cc19" => :high_sierra
    sha256 "79cfd56848515fd4eff7620be3c25e2fd75131778b319a9e70f075b46f0251be" => :sierra
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
