class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", "Bitstream-Vera"]
  revision 6
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bc1152802bbc0c177b8da999c6221a7c229fb2c6fc104fe8135dcfe0691062f4"
    sha256 cellar: :any,                 arm64_sequoia:  "bdcf533595e5ae4f13cde425c0e06c515257045288acddad4b9530ce3c949394"
    sha256 cellar: :any,                 arm64_sonoma:   "f2798a7e39c570fb3f16f223658233ed9d4f273bfb079851d5b23ad7ee3279c4"
    sha256 cellar: :any,                 arm64_ventura:  "6892fd7487390e10f9a9353e0ed478bbaae9492f458cc26ce6e28bb152d9ba23"
    sha256 cellar: :any,                 arm64_monterey: "9d7499f1d328a6a4b91e22b90ded73a9ba3f4147cddff1d27e6a38a0f009378b"
    sha256 cellar: :any,                 sonoma:         "04408ea5d216f20bf717bff54479860587047d3ba6f461dffb2ad44abdad6ca3"
    sha256 cellar: :any,                 ventura:        "3283e3c2fc6119cdb90fea04630036f3e2db8e614aacb4190910d23afb722d1c"
    sha256 cellar: :any,                 monterey:       "03c79e5c09db8d0a39e66e8f79ed7ef2fb39c5d1a7760ac3b5979a74a309a61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3073343041a2759f07e44132a6ac86238e34660549a7b8df8e7b05aa28fa52f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d9642c0028543fc3452e204831c3d675c121fb756fd7376f9c6f879adbaea5a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  # TODO: Remove resource once new release is available or hackage revision (r2+) with
  # equivalent changes (https://hackage.haskell.org/package/sdl2-2.5.5.0/revisions/).
  resource "sdl2" do
    url "https://hackage.haskell.org/package/sdl2-2.5.5.0/sdl2-2.5.5.0.tar.gz"
    sha256 "23fdaa896e528620f31afeb763422d0c27d758e587215ff0c1387d6e6b3551cd"

    # Backport increased upper bounds for dependencies
    patch do
      url "https://github.com/haskell-game/sdl2/commit/7d77a910b176c395881da3bf507a6e1936a30023.patch?full_index=1"
      sha256 "eee6b20184b9a86adf3fdfb36b5565bde2e0845f0b0d9edf37872d6abfe3248e"
    end
    patch do
      url "https://github.com/haskell-game/sdl2/commit/5c92d46bebf188911d6472ace159995e47580290.patch?full_index=1"
      sha256 "570ad5c52892709e19777eb2e9aa6773c0626ce993fbc775c1d1a3ae3674af2f"
    end
  end

  def install
    # Workaround to use newer GHC
    odie "Check if workaround can be removed!" if build.stable? && version > "0.11.0.0"
    (buildpath/"cabal.project.local").write "packages: . sdl2/"
    (buildpath/"sdl2").install resource("sdl2")

    # Workaround for GHC 9.12 until https://github.com/tfausak/witch/issues/117 is fixed
    args = ["--allow-newer=witch:base,witch:template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_empty shell_output("#{bin}/Allure --dbgMsgSer --dbgMsgCli --logPriority 0 --newGame 3 " \
                              "--maxFps 100000 --stopAfterFrames 50 --automateAll --keepAutomated " \
                              "--gameMode battle --setDungeonRng \"SMGen 7 7\" --setMainRng \"SMGen 7 7\"")
    assert_empty (testpath/".Allure/stderr.txt").read
    assert_match "Client FactionId 1 closed frontend.", (testpath/".Allure/stdout.txt").read
  end
end
