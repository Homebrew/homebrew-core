class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 3
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "7b817a675a66d28cd4d431ebe632f191c008268dd6e4e220f4f0a2ba537b0214"
    sha256 arm64_monterey: "6ae827beabe27357dc2508cb2df02ee6fc91334b82b89f7f224c1b2d1547f950"
    sha256 arm64_big_sur:  "b5575dc7c4003a656fd86e9bb6ccc1bb32ca6e7cc69b269b5119185fe026d4ef"
    sha256 ventura:        "a55f0d42d41db620f24a58b4254e201805f096f9df3900bc73d4494992c7ff9d"
    sha256 monterey:       "2c92d0873b2bdf32c9ab2950c6e2c5c534160a077ab8b708a9a79364cc2caf4e"
    sha256 big_sur:        "bae28a26bd04288ed862ba47abce420f52ac48a647e3d6ee9cb05e0ccd8cceb3"
    sha256 x86_64_linux:   "9ea9c63c0ce29a8397987c038517853faf066e95b9967e7ff436797177d0a00c"
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
