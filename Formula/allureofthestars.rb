class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "9bd3f439b8be07f96b479607cbfa0c09a05341ee185eb2b2f8cb535ea07949e7"
    sha256 arm64_big_sur:  "7ef16dbc819f8d30a4d1c903c9c0f0c463b9ee020966587ff14ab5c06447cd33"
    sha256 monterey:       "f755a0392edfa915f1f2f09ae15fbc5928539d1cf73c1a8f0dedb047e716e32e"
    sha256 big_sur:        "d2b692c624297b9fc02d985f0f1a760f269c5d8a2b0a6b822b6ef1c80a416a51"
    sha256 catalina:       "94c49064f02785a6da670e54ab38691b35af533a525395a3c9523fd156acf97f"
    sha256 x86_64_linux:   "9a273be68a0480534a4f6fff161837deba8cab1b23f3c4d1ec762a578137374b"
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
