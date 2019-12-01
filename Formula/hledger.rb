require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.16.1/hledger-1.16.1.tar.gz"
  sha256 "aa764da8caea4d8937220d502020d6b8bc69bd05b9630874bed144f9a42680b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "538e946ba6dbe3102a4d13aec532685a151dd40653ed2dd08965886230ed2431" => :mojave
    sha256 "ec183c76ea4d687ed79cce0024087506a00f95af1a7c39774dd91fa88067dfeb" => :high_sierra
    sha256 "c9e3cf75046e98b65e04055b7f2b96eb3c441d031e4f9d28b01485275886a618" => :sierra
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
