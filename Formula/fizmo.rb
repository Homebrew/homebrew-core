class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.5.tar.gz"
  sha256 "1c259a29b21c9f401c12fc24d555aca4f4ff171873be56fb44c0c9402c61beaa"
  revision 1

  bottle do
    sha256 "5bc934e9ac29637cc4a533ffbac0d3e1807d6f70797920eeb80e2e0a9c0cae20" => :high_sierra
    sha256 "86d6479347bf687c17da9b0b8eef22d0e332701c3ef7cfee50c7487273aa3445" => :sierra
    sha256 "2b50bdff9322ebc50f10fba89a098f9fc05157243e0f0c1dcecf5686a6988fa2" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :x11
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/fizmo-console", "--help"
    # Unable to test headless ncursew client
    # https://github.com/Homebrew/homebrew-games/pull/366
    # system "#{bin}/fizmo-ncursesw", "--help"
    system "#{bin}/fizmo-sdl2", "--help"
  end
end
