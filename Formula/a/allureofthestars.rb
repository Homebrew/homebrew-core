class Allureofthestars < Formula
  desc "Near-future Sci-Fi roguelike and tactical squad combat game"
  homepage "https://www.allureofthestars.com/"
  url "https://hackage.haskell.org/package/Allure-0.11.0.0/Allure-0.11.0.0.tar.gz"
  sha256 "6125cc585e2a5f28c88855c3c328385c1f21bed093d7606478f1b2af0cb2b6d6"
  license all_of: ["AGPL-3.0-or-later", "GPL-2.0-or-later", "OFL-1.1", "MIT", :cannot_represent]
  revision 3
  head "https://github.com/AllureOfTheStars/Allure.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "fd0bcad13d8a72f0fb647abaa816ea6a89e9accb379a95087a9330a2cbbb9c45"
    sha256 arm64_monterey: "9def42a925523a981ef37509734525f66c88670ad496bd050c254f50c604756b"
    sha256 arm64_big_sur:  "001b7aa8f3cf6a01bf268800506307af8aaa93f9cbc35b0aeba3c9448d71b5bd"
    sha256 ventura:        "578478ee4183c38ace3983f088fab57dd1bd85a43dbb2bf2467e1d54c72ca832"
    sha256 monterey:       "ca27c6cac20911aecada5b64b9945df16294934ce67fd16cd893635b8ba80f55"
    sha256 big_sur:        "4f52a679dc9e50a12d6f3e63ed1ad997c81f6f83d426313ef9cf43d13874e4c3"
    sha256 x86_64_linux:   "3d61f7f1f7d957c035bd84a8260ce7807115c7b989299cb205469a2a0fa75035"
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
