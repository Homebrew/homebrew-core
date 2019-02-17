require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.13.2/hledger-1.13.2.tar.gz"
  sha256 "9b57e78c9c51f06c0fbc8dd499baad8fe2f323635c95159f55b041ebe12fbc37"

  bottle do
    cellar :any_skip_relocation
    sha256 "40779fdb6412f4f35b017e3c5fc2b73dc953e742249de6c08fe95fc6fc94b98c" => :mojave
    sha256 "ad5678930a660e6d0e4e35b03ab13f8a9871800026f9a2c2f0429ce828d582a8" => :high_sierra
    sha256 "bfec5f6b7608d17bff44d123b8baae7fb0378886b8268c89a924daacd2d64d73" => :sierra
  end
  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  resource "hledger_web" do
    url "https://hackage.haskell.org/package/hledger-web-1.13/hledger-web-1.13.tar.gz"
    sha256 "d7621eccc151841458b7a2b6b1ce86585d98d88d4aa50e4dca22e9be2985ab10"
  end

  resource "hledger_ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.13.1/hledger-ui-1.13.1.tar.gz"
    sha256 "d7f773cf626e0d67df505e2f1f10111e49097690324eb4d4272223c4ec7e4e49"
  end

  resource "hledger_api" do
    url "https://hackage.haskell.org/package/hledger-api-1.13/hledger-api-1.13.tar.gz"
    sha256 "e3f2387fe4be671fcbef10184e4b0a4d895d29a40470aaedb36baad731a871de"
  end

  def install
    install_cabal_package "hledger", "hledger-web", "hledger-ui", "hledger-api", :using => ["happy", "alex"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-web", "--version"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-api", "--version"
  end
end
