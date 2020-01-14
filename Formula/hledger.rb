require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.16.2/hledger-1.16.2.tar.gz"
  sha256 "b4b78b3f08d00ca75c6f6d47b37c0a67aec4adc0aefff2ca29bb0f3b82ac7bcb"

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
    url "https://hackage.haskell.org/package/hledger-web-1.16.2/hledger-web-1.16.2.tar.gz"
    sha256 "daa4b68d8491d0a5716ee2ac39520a31bef6a1ae6b36ddc0f531b81616c237ce"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.16.2/hledger-ui-1.16.2.tar.gz"
    sha256 "90f69e1e2f9fa66c535b7f61144b3fb681f1629f313c89d423b4569722224faf"
  end

  def install
    install_cabal_package "hledger", "hledger-web", "hledger-ui", "brick-0.50.1", :using => ["happy", "alex"]
    # help cabal pick a good brick version, https://github.com/Homebrew/homebrew-core/pull/49010#issuecomment-574719702
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-web", "--version"
    system "#{bin}/hledger-ui", "--version"
  end
end
