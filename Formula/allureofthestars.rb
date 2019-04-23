require "language/haskell"

class Allureofthestars < Formula
  include Language::Haskell::Cabal

  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "http://allureofthestars.com"
  url "https://hackage.haskell.org/package/Allure-0.9.4.0/Allure-0.9.4.0.tar.gz"
  sha256 "503cd08dd6dd71d0afe63920b8fa171047449e95a35369dab0936c490d3dabf4"
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    sha256 "342d8a5a02719e571c503484df6d130d20d3fa9b94bd42bfb10767816aad89e3" => :mojave
    sha256 "c7237ae3122cb2434148325b12849679236897594d8b65e64e8c2675f99c8b1e" => :high_sierra
    sha256 "fb3ce9cc7690dfb71e65f224c292368052983a8046f92ae2553ad034045c214f" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2_ttf"

  def install
    install_cabal_package :using => ["happy", "alex"]
  end

  test do
    non_debug_args = "--logPriority 0 --newGame 3 --maxFps 100000 --stopAfterFrames 50 --automateAll --keepAutomated --gameMode battle --setDungeonRng 7 --setMainRng 7"
    output = shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli #{non_debug_args}")
    assert_equal "", output
    assert_equal "", shell_output("cat ~/.Allure/stderr.txt")
    assert_match "UI client FactionId 1 stopped", shell_output("cat ~/.Allure/stdout.txt")
  end
end
