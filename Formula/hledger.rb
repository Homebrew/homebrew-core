require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.5/hledger-1.5.tar.gz"
  sha256 "0185e2d24a72eae917ca08a8d1de42dceeb93357331c1162156a7adaa092af56"

  bottle do
    cellar :any_skip_relocation
    sha256 "126f06d1834f603f412ae656c28dc2ecdf6adaa6bdbc55154def1f87bbf46814" => :high_sierra
    sha256 "67cf9c8b5ba330902abc89484de6bb78b863471a6d7afa64a32d5b2cbdba0275" => :sierra
    sha256 "a4d14f951b5eb3265229c3cb6c33080d29e5fa1360db9c1878460c39183e57b6" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
  end
end
