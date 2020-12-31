class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.9.5.0/Allure-0.9.5.0.tar.gz"
  sha256 "8180fe070633bfa5515de8f7443421044e7ad4ee050f0a92c048cec5f2c88132"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 1
  head "https://github.com/AllureOfTheStars/Allure.git"
  # Test, do not merge

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d82455c81cf0a631109ea16ae197fbce21ba141a7d4af065e38f67bf9d03438c" => :big_sur
    sha256 "542feabc974e7b3506e46312dbe3aaaae6f03474708c969520c661edaf0da088" => :catalina
    sha256 "adfd9f24390bac8ea4d661bbdde89c2d96187f6ad6e1045c4ed495e1ec6db275" => :mojave
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
