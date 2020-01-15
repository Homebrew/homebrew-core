require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.16.1/hledger-1.16.1.tar.gz"
  sha256 "aa764da8caea4d8937220d502020d6b8bc69bd05b9630874bed144f9a42680b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "7632ee3eba6efc1421a1423b608d3d9594f2ea95fe5e48ecd6aa74f4f23a2fcf" => :catalina
    sha256 "729176606235e133a78cb114eb445adbb6845156d52bf58cccbf59cace19e1cf" => :mojave
    sha256 "8f64c97525829e500a89d9533d21b13413c96f8575730f4354d2a6b98ab1bf2f" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.16.1/hledger-web-1.16.1.tar.gz"
    sha256 "4517bedc6155c89c3cf7b7403190bcdd3969094e68220605fd6b2ab3c9acc3d6"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.16.1/hledger-ui-1.16.1.tar.gz"
    sha256 "c120bc9b968faccb827fcc19382e3c629f20772168a7606a3171d38332bfc132"
  end

  def install
    install_cabal_package "hledger", "hledger-web", "hledger-ui", :using => ["happy", "alex"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-web", "--version"
    system "#{bin}/hledger-ui", "--version"
  end
end
