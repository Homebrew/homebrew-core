class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 5
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "a38ce85edb205deee1399d70dae80d003e94f0431f106bdf0a8958c5fe13b240"
    sha256 arm64_ventura:  "90f87ed1d51792f211be0b35d48bddc18bd4e984353eb6b6352ad16b36f593d9"
    sha256 arm64_monterey: "b214cd406160b0ec5ebd89d97de99c17239864e6f741fc5d4c3aa8258f0a614b"
    sha256 sonoma:         "568ffd7f5056eeb49845f2c6937be34eec44a1e09334e064cc56f6eb0347ee21"
    sha256 ventura:        "ae7d58df8a64bb36e754132c60ab86d4889ae53641e6b726cccb903779896dce"
    sha256 monterey:       "948b5d1218f533733cf6295db441f4e75b315d247b53af78d4659966e25a084e"
    sha256 x86_64_linux:   "2cf4dbce048d750857d233ee5b0f83be759b8b4302fe166003ddecb9babd1c07"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc@9.6"
  depends_on "gmp"
  depends_on "sdl2_ttf"

  def install
    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_empty shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 " \
                              "--maxFps 100000 --stopAfterFrames 50 --automateAll --keepAutomated " \
                              "--gameMode battle --setDungeonRng \"SMGen 7 7\" --setMainRng \"SMGen 7 7\"")
    assert_empty (testpath/".Allure/stderr.txt").read
    assert_match "Client FactionId 1 closed frontend.", (testpath/".Allure/stdout.txt").read
  end
end
