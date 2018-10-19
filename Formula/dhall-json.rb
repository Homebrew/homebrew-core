require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.4/dhall-json-1.2.4.tar.gz"
  sha256 "e594b47a168c47225d929d94c8dce12b9b32a195c9faa02ff091b3f18adb63e7"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91af2ae4f9addfbd2c1306e7f660a0a5b39270e6d8520c751869d9d4e28fd8b4" => :mojave
    sha256 "0999257e3591390c4a6ad2d34dcb3f45725981d92e9eefd7fa9014576145c3a8" => :high_sierra
    sha256 "a7824906fe27a42a77e78a8ffeb45a052b5d24c403beb608a3d65dc385b0c31b" => :sierra
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
