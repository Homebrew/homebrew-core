require "language/haskell"

class Allureofthestars < Formula
  include Language::Haskell::Cabal

  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.9.5.0/Allure-0.9.5.0.tar.gz"
  sha256 "8180fe070633bfa5515de8f7443421044e7ad4ee050f0a92c048cec5f2c88132"
  license "AGPL-3.0"
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    rebuild 3
    sha256 "cdcc579293d895e65bdfd907c2ab4d66db89e0389f78df9acaf1ea556ea47c63" => :catalina
    sha256 "4b18f47a9ade6d260030488503b5bb3021ae523cf3b54960c8092495f0ffd47c" => :mojave
    sha256 "2a056d85e8a4794158435ca324f7bc81d8dcb098770ec1d3d288dfcc77553c47" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "sdl2_ttf"

  def install
    install_cabal_package using: ["happy", "alex"]
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
