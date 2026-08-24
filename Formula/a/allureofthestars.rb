class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", "Bitstream-Vera"]
  revision 6
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "0cce7783d31164730863db9afeeae32c81412a5d70ce9f6d6287266191cdffc3"
    sha256 cellar: :any, arm64_sequoia: "1473587658292222a91e20f436d7753e552294cc27d7883365fa9d1a32b31766"
    sha256 cellar: :any, arm64_sonoma:  "b0870f99c72b0c4a6fabba57dd9812bcee98fa842abccac53596c4bfd87f8a1d"
    sha256 cellar: :any, sonoma:        "9cd14d1633fa5dca71ca93c3a31160e42f6ad83288eed2180884890e79a69c1c"
    sha256 cellar: :any, arm64_linux:   "8695e01b93d5c370de9d547cfe4ec8f66f75fe984b650f413ee1f49ff64fc143"
    sha256 cellar: :any, x86_64_linux:  "2b9650506f70289e5bc2f9b2b0167a2f7cfc66365134e0c6ed088bdb9ee75d7a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "sdl2-compat"
  depends_on "sdl2_ttf"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_empty shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 " \
                              "--maxFps 100000 --stopAfterFrames 50 --automateAll --keepAutomated " \
                              "--gameMode battle --setDungeonRng \"SMGen 7 7\" --setMainRng \"SMGen 7 7\"")
    assert_empty (testpath/".Allure/stderr.txt").read
    assert_match "Client FactionId 1 closed frontend.", (testpath/".Allure/stdout.txt").read
  end
end
