require "language/haskell"

class Allureofthestars < Formula
  include Language::Haskell::Cabal

  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.9.5.0/Allure-0.9.5.0.tar.gz"
  sha256 "8180fe070633bfa5515de8f7443421044e7ad4ee050f0a92c048cec5f2c88132"
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    sha256 "26fff57df9c461c021711d86d823b0d55789878063686dba5c303f24e02f43a9" => :mojave
    sha256 "eee43f8b33142a2734dc474175f579d5e747470f8f3049f4e38433dbea30aa31" => :high_sierra
    sha256 "f6235d97b2935adcd24d130a27337d40ef16b9051b066a896471273d3c7aa1d3" => :sierra
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
