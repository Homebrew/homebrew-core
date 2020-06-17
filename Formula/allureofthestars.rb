require "language/haskell"

class Allureofthestars < Formula
  include Language::Haskell::Cabal

  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.9.5.0/Allure-0.9.5.0.tar.gz"
  sha256 "8180fe070633bfa5515de8f7443421044e7ad4ee050f0a92c048cec5f2c88132"
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    rebuild 2
    sha256 "e8e53b6165ef8de7a92048a5768cbbb17d0901a0c4f3fbb34eb57d79eaa8fe4f" => :catalina
    sha256 "89d961dd52842e4ec8e44d40fe0f5385845792637f836108dabee5cadc91fe9d" => :mojave
    sha256 "3f8b9d0a2e203c896ae4a0a1a340f5e794f5ff6d26203195669de31ecd116c53" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "sdl2_ttf"

  def install
    install_cabal_package :using => ["happy", "alex"]
  end

  test do
    assert_equal "",
      shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 --maxFps 100000 " \
                                 "--stopAfterFrames 50 --automateAll --keepAutomated --gameMode battle " \
                                 "--setDungeonRng 7 --setMainRng 7")
    assert_equal "", shell_output("cat ~/.Allure/stderr.txt")
    assert_match "UI client FactionId 1 stopped", shell_output("cat ~/.Allure/stdout.txt")
  end
end
