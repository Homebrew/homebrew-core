require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.3/hledger-1.3.tar.gz"
  sha256 "ade9800e4a3fab47b48c6cdbe432d261f3398f71514eb2c554a14f8f8c542f2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "18d3c9572ce9650ed53471cbe36b581fb7265c98028aae58ce0a105ab8f547ec" => :sierra
    sha256 "94dee5018dd460923375177611925e11e2b9b2ddb83c20e69b946b830059b456" => :el_capitan
    sha256 "15038796cdab0dd16bbd3a7d42344bbea4ba1694b2ecda0e0b7d8a1f87765768" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/hledger", "test"
  end
end
