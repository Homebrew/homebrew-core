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
    output = shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 --maxFps 100000 --stopAfterFrames 50 --automateAll --keepAutomated --gameMode battle --setDungeonRng 7 --setMainRng 7")
    assert_equal "", output
    assert_equal "", shell_output("cat ~/.Allure/stderr.txt")
    assert_match "UI client FactionId 1 stopped", shell_output("cat ~/.Allure/stdout.txt")
  end
end
