require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.15.1/hledger-1.15.1.tar.gz"
  sha256 "c9be087b72735411554bc058178a4b084a48d5ab2a18bce259c40ead6d331866"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8f717413411bf98616d3df20f31583928b8b93e937080632e08677512cd9d5b" => :mojave
    sha256 "5150a38fc8378410ca9b7b9d2fca755ccc7fe0eef6805fc07650fd836460a0bb" => :high_sierra
    sha256 "60422bb49e6e62f26780cec246007cfa38dc8fcb33c6718591e7f7e72fb44c2a" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  uses_from_macos "ncurses"

  resource "hledger_web" do
    url "https://hackage.haskell.org/package/hledger-web-1.15/hledger-web-1.15.tar.gz"
    sha256 "837f527c7e611c1f2830a37314076825bd2c8f7364439860fe8a7e1736aaa4d4"
  end

  resource "hledger_ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.15/hledger-ui-1.15.tar.gz"
    sha256 "38e8c1ad6e7076345914dfc0df3f0801713550fa80343b6130b8dfd363d5fa10"
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
