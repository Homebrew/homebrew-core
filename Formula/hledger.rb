require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.3/hledger-1.3.tar.gz"
  sha256 "ade9800e4a3fab47b48c6cdbe432d261f3398f71514eb2c554a14f8f8c542f2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a610bd5c0f4dbc1f98d83888b944212d0d5608caae8cf658c6004126c6a9fb8a" => :sierra
    sha256 "2a53f7ca6d0f99fe6c439497fb1e0f2ca84028683c9cb40e0f344b1fc7c115f1" => :el_capitan
    sha256 "b2347dcf7e7abb6877c1fd5e95c3fedef2ffe044726b7a29e7cc609cb656c70e" => :yosemite
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
