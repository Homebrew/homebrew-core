class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.10.2.0/Allure-0.10.2.0.tar.gz"
  sha256 "fcb9f38ea543d3277fa90eee004f7624d1168bf7f2c17902cda1870293b7c2f4"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 2
  head "https://github.com/AllureOfTheStars/Allure.git"

  bottle do
    sha256 arm64_big_sur: "5d4b52ab398c06ea763ada17bbcc5ce1809e7fa41ca86d51e84a1b735e2bf1fc"
    sha256 big_sur:       "520edb58cb488698e8d7684072a3ad0fb60380eb5142d2aa9c93577755f93f02"
    sha256 catalina:      "cb7ee8b10d01e3ed930b003c2f0bc56a6430da78c0dc2d4f7b478412f87cc322"
    sha256 mojave:        "ed9c63c9bce1bbd78e176f839bf948696fc59f37c9c23ac86bdf4689903f104f"
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
