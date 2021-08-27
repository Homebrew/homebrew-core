class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.10.2.0/Allure-0.10.2.0.tar.gz"
  sha256 "fcb9f38ea543d3277fa90eee004f7624d1168bf7f2c17902cda1870293b7c2f4"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 4
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "59ddc0a4fa96df726badfaf3684cfae9027178048c3669d86d78bb2a3afecc6b"
    sha256 big_sur:       "662de0184a9b825c8fc90ff9ea5115519640fc97903a3ffe9f1b0d5c53c6c911"
    sha256 catalina:      "e103a1de23ff3389bc15034b9f7e2f8271bf48433367b526ccf081e779dac13e"
    sha256 mojave:        "86256ce82dd50aba31201d5b487905121f4024b08c30ead8079022e17112f23a"
    sha256 x86_64_linux:  "668901a1585204e0f11d1fceddbc8cb008d53f527d71dd7056ee8b15374a7a11"
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
