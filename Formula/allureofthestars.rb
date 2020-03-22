require "language/haskell"

class Allureofthestars < Formula
  include Language::Haskell::Cabal

  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.9.5.0/Allure-0.9.5.0.tar.gz"
  sha256 "8180fe070633bfa5515de8f7443421044e7ad4ee050f0a92c048cec5f2c88132"
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    rebuild 1
    sha256 "d568c44d9f158ac188d690a0366950923b565aebf3c82a6b718c52d8584b29e5" => :catalina
    sha256 "81f6960b26c310bea1b253768edfc00c8c38b84d2651a6d3b9e0dc3434b7cd04" => :mojave
    sha256 "893be6de189e97cb416e0e0f8ee8b73ce663a57fa4593a32c76ac69f987f64ab" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
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
