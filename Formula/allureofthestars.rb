class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.10.3.0/Allure-0.10.3.0.tar.gz"
  sha256 "0ae3ffbdf8bff2647ed95c2b68073874829b26d7e33231a284a2720cf3414fdc"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "cde6ae4feb79ecd891aafa2d4d0ebbbbe140a2d71b86770a8f46479c2165f0e2"
    sha256 arm64_big_sur:  "d5e1044e0fc88046d9a25881d4474f1b717aa45351e88c3a2cb468a7b963351b"
    sha256 monterey:       "39a6422266e1c94f31bc3b58554f8e2558e27bd37e9c3a884a5e3d7166e9014f"
    sha256 big_sur:        "3cdd74a916009522c1311f9c5652b14b9fbd3b6efd2f5bceed76e4e38ee83d08"
    sha256 catalina:       "9cce7401b41c975014dffb656baa00077e71ee580c25773725f57ce79acec98c"
    sha256 x86_64_linux:   "e3926e9981b416b9bd8698ea5ab721b5b38b1fd374e228d4ec6e3e3ecbe34e5c"
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
