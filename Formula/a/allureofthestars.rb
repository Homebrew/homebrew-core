class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", "Bitstream-Vera"]
  revision 6
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "786bcd9f1837c4e3c9c5f4663251c4b10ea6e60cfb31adb8b0532e6e575edbf8"
    sha256 cellar: :any,                 arm64_sequoia: "541d886f3d5a909201ccf527cdecb88cab24cded8a70ef8270db759ae6d1dff0"
    sha256 cellar: :any,                 arm64_sonoma:  "b9f555b1d4975c7557363b1d60ebdd0881824986a2e8cd374ab30bcb669241bf"
    sha256 cellar: :any,                 sonoma:        "44c9d439e03e805411e9ae5226bb09de0ea12a1d5995d2bafa8ecc172318b355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "962870edbfbb1f10a5dcf07ffd5e92cbdcf23e60435e780962c923979619e785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3fc6ce4dca4b6c6a4274bc6c5249228f50616098ca990b9b0d055c2cb725852"
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

  # TODO: Remove resource once sdl2 >= 2.5.5.1
  resource "sdl2" do
    url "https://hackage.haskell.org/package/sdl2-2.5.5.1/sdl2-2.5.5.1.tar.gz"
    sha256 "25b3e2410129c16c2cea56137319206fa1b792dec6634f07a7ea4d9031ffc0cc"

    # Backport fix
    patch do
      url "https://github.com/haskell-game/sdl2/commit/73db004e1ffefe5767edb62271c51ee3e8b6af48.patch?full_index=1"
      sha256 "22daee1181c49f218592085912ff8b0ba1dc2487948759d11ab42bfc054faed5"
    end
  end

  def install
    # Workaround to use newer GHC
    odie "Check if workaround can be removed!" if build.stable? && version > "0.11.0.0"
    (buildpath/"cabal.project.local").write "packages: . sdl2/"
    (buildpath/"sdl2").install resource("sdl2")

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
