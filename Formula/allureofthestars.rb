class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.9.5.0/Allure-0.9.5.0.tar.gz"
  sha256 "8180fe070633bfa5515de8f7443421044e7ad4ee050f0a92c048cec5f2c88132"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 2
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    sha256 big_sur:  "d43def961fa93b09b7e892555cfa10f98ccb4d8951f5f0f1a042e21984c45406"
    sha256 catalina: "f672e5207dc9741953f256add1c906f12f92f288d9a3f674323302e76401d1bb"
    sha256 mojave:   "8f34aba3fc290ecfa4f938b32bfbf0c3f9955ab657223a514a0fe30223e34e8f"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc"
  depends_on "gmp"
  depends_on "sdl2_ttf"

  def install
    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_equal "",
      shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 --maxFps 100000 " \
                                 "--stopAfterFrames 50 --automateAll --keepAutomated --gameMode battle " \
                                 "--setDungeonRng 7 --setMainRng 7")
    assert_equal "", (testpath/".Allure/stderr.txt").read
    assert_match "UI client FactionId 1 stopped", (testpath/".Allure/stdout.txt").read
  end
end
