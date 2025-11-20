class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.5.tar.gz"
  sha256 "1c259a29b21c9f401c12fc24d555aca4f4ff171873be56fb44c0c9402c61beaa"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url "https://fizmo.spellbreaker.org/download/"
    regex(%r{href=.*?/fizmo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "84b3dabce41fa7fd0883ff4cc412d65b73d42da0b9f5968db0570df314ba20d7"
    sha256 arm64_sequoia: "25c9f7c41969ef25f4487be678d26f761384e6f13aed58856138c6c5cea6a3f1"
    sha256 arm64_sonoma:  "62635a4d8f0c4ac90a551e1fd1e6a8ca823c436654f3c467c2a58436457e4102"
    sha256 sonoma:        "28a1e73cd22c90f530ff66da225fc5d2a0b83cd851cce66ff2a4e39397930ad9"
    sha256 arm64_linux:   "6a6002114ad34ebc2792bab4d6d230e1f7bb206a88dd4e86d2764fead910d111"
    sha256 x86_64_linux:  "c21432000515a2c9e3d51d38f66d0bc3203baedc971da06ab80f4b650e4f8c08"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libx11"
  depends_on "sdl2"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fizmo-console", "--help"

    # Unable to test headless ncursew client
    # https://github.com/Homebrew/homebrew-games/pull/366
    # system bin/"fizmo-ncursesw", "--help"
    system bin/"fizmo-sdl2", "--help"
  end
end
