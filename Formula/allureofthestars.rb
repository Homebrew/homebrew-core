class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.10.2.0/Allure-0.10.2.0.tar.gz"
  sha256 "fcb9f38ea543d3277fa90eee004f7624d1168bf7f2c17902cda1870293b7c2f4"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 2
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    sha256 big_sur:  "78a5ef2eb30f4edd645a29401e4eb133f70614a4e25882b7fe1f22809af1e96c"
    sha256 catalina: "fbf64538227d75bab61b4ae7ba36b2c22a15da021e8e892c213877f996268aef"
    sha256 mojave:   "98a71cea59c291a34d58514b84e040d7043a8e64621248be51988d7e332ca906"
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
