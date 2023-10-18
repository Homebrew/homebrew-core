class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 4
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "96324c6d47eef0d6b553d386be321a0af09bf887525194f25c867747e15f1b8b"
    sha256 arm64_ventura:  "64c1ac53a1ffaf24754fbddc8e86b70e75a8eba582fba7a306c5dba1138a6e6f"
    sha256 arm64_monterey: "1c93c60267ec41f5e43d77e3587c8f96cc1d25ed0073cb273130385ac6b47608"
    sha256 sonoma:         "72ea11b9f829e851049158618f80d48cc67ba0c7ef66c5f60b4bb9a9c0778130"
    sha256 ventura:        "06cef61b36f5cb354b20d4143529dc0490155e803dc8ac83ad764b5d44eafbb6"
    sha256 monterey:       "e56887ff46b9f01c409d5f0ff6424cc77d025b6fca072518628275f123d7cab1"
    sha256 x86_64_linux:   "af9f15398518cdb0e5045f9e419ad17c80911d9e10ebf916f1fd4841f6ee6437"
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
    assert_empty shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 " \
                              "--maxFps 100000 --stopAfterFrames 50 --automateAll --keepAutomated " \
                              "--gameMode battle --setDungeonRng \"SMGen 7 7\" --setMainRng \"SMGen 7 7\"")
    assert_empty (testpath/".Allure/stderr.txt").read
    assert_match "Client FactionId 1 closed frontend.", (testpath/".Allure/stdout.txt").read
  end
end
