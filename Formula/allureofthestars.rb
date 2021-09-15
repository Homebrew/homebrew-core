class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.10.2.0/Allure-0.10.2.0.tar.gz"
  sha256 "fcb9f38ea543d3277fa90eee004f7624d1168bf7f2c17902cda1870293b7c2f4"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 4
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "35f81924e44e1dbb5b3afdb9447117622f6fa31388722f3ba4326641e3399eb7"
    sha256 big_sur:       "07130a7da685c1df7dfc4231696b3819edac6ef3f4626796a4b7a01c9d8e1bba"
    sha256 catalina:      "522ebd08dd14793bcf72c9cc260d2d1649a394c35941db6476baec2c7c441a85"
    sha256 mojave:        "7f3af277723076c9b3dae13fbf597a24d92069cd2aca02e9628de915036a3f04"
    sha256 x86_64_linux:  "96891cb7896bc936721f38f9d0ce62f3dc9675d245345d5e2ecf3bb68396763b"
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
                   "--setDungeonRng \"SMGen 7 7\" --setMainRng \"SMGen 7 7\"")
    assert_equal "", (testpath/".Allure/stderr.txt").read
    assert_match "Client FactionId 1 closed frontend.", (testpath/".Allure/stdout.txt").read
  end
end
