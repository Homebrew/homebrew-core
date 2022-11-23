class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 1
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "e9fc754df55dd4f847fa243857044a1f709aa3ddb3ab2d6c546acc417e565057"
    sha256 arm64_big_sur:  "e803ba4913b166fc125412cc604f9f1c2069d6ba0fe43d3a1b97d31baec2824a"
    sha256 ventura:        "1d22318774732d6d9eee2ea361efe5ddda52bde6c4f0a848be2642644d360e41"
    sha256 monterey:       "bc8b0af2c7a18f51970e25aa5b128b566cac20598527576bcb42d1f37d204569"
    sha256 big_sur:        "9b943037f3426c5b10f2bd0c021d7ccf596341f1241e92bd29d9d24aefcc9163"
    sha256 catalina:       "ed1f07f254c85c52c4d906a682a8cc5ddc2bb7c662abf3adbf73ad966b150afc"
    sha256 x86_64_linux:   "b5e4e22f6538f1e1c9c759345b9d665d775b7685f7d8934a38986fd490128502"
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
