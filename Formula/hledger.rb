require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.15.2/hledger-1.15.2.tar.gz"
  sha256 "3d62b1c948ed9bf826a1250098d20c22b3de876993f3089a9ee4a6505091b79a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c50010909175b8c4cdf8816267b0c009f5c3424d2576d29fb69ebc64a5b57fb8" => :mojave
    sha256 "a9bff69b687e8efd483b7aa34992ed053bcd8cf9130e67c4e3206da35086480c" => :high_sierra
    sha256 "0e42ce16a4a47038656e83fe0e7e2e1b87517228ddd3c9d43bc7f60657ff5ec0" => :sierra
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
