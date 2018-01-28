class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.5.tar.gz"
  sha256 "1c259a29b21c9f401c12fc24d555aca4f4ff171873be56fb44c0c9402c61beaa"
  revision 1

  bottle do
    sha256 "8f712f9199f9b0dd2ff31e09f8cd48c6796592b7f06f14d78fd3a5c56a661ea8" => :high_sierra
    sha256 "fcde25bc1e4eb7f481d132e8da671c7eb445fe3139a1f1784aff830e353332a6" => :sierra
    sha256 "49943781111aafa7f1a1094bd79f6faea13e168d51119ae2d84a9f74ad9e4008" => :el_capitan
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
