require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.9.1/hledger-1.9.1.tar.gz"
  sha256 "630116f8b9f6edeb968e863600c9501628a805dd1319a5168ab54341c3fc598d"

  bottle do
    cellar :any_skip_relocation
    sha256 "565012c295cccdf2458a7c8b97a753406dce0dff3272a3195f3c9603a93532bf" => :high_sierra
    sha256 "783c9ac9f6f52c2980e228f67f5bc27cf06c3bcfe36d6493f47164374a57ed26" => :sierra
    sha256 "1701f551254a3e7d1cd76abc881e2080d0431f2d70bd25932653b508a80a8999" => :el_capitan
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
