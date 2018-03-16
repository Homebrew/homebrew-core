require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.5/hledger-1.5.tar.gz"
  sha256 "0185e2d24a72eae917ca08a8d1de42dceeb93357331c1162156a7adaa092af56"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2145cc00496a8a2e2946c66c67e0dfde353cef519a3ce1786ffc7cbc3f32878" => :high_sierra
    sha256 "fe76d9dcce6415a1bc134d81a8ca640256cccd72deea69d236c6d66df2e7bd8a" => :sierra
    sha256 "1951e3a98d81fd781cb0c70c9f8f749095f91d0699ac8b6a2b8aecb14dfc8543" => :el_capitan
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
