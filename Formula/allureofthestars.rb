require "language/haskell"

class Allureofthestars < Formula
  include Language::Haskell::Cabal

  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "http://allureofthestars.com"
  url "https://hackage.haskell.org/package/Allure-0.9.4.0/Allure-0.9.4.0.tar.gz"
  sha256 "503cd08dd6dd71d0afe63920b8fa171047449e95a35369dab0936c490d3dabf4"
  head "https://github.com/AllureOfTheStars/Allure.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2_ttf"

  def install
    install_cabal_package :using => ["happy", "alex"]
  end

  test do
    system "#{bin}/Allure", "--version"
  end
end
