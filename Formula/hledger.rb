require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.9.1/hledger-1.9.1.tar.gz"
  sha256 "630116f8b9f6edeb968e863600c9501628a805dd1319a5168ab54341c3fc598d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b98a55685dc4c619e59f102c91b75af384711b4d41ad05a184cec258cc5f9995" => :high_sierra
    sha256 "7ca8c6444c3f5226f7e7831d31c9f389aa2f56540c9f9310a5b3842520dbffac" => :sierra
    sha256 "59566873ae4f71158ea1f0ea4a551372a5b3b88bc121347d620428d4e30b326a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
  end
end
