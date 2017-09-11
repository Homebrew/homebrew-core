class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.5.tar.gz"
  sha256 "1c259a29b21c9f401c12fc24d555aca4f4ff171873be56fb44c0c9402c61beaa"

  bottle do
    sha256 "1d7086e1db185650e7fa5a7bd77719e21e7acf71d99d05e3e91d1ab0e8485d6a" => :sierra
    sha256 "496cb25c39256ad1cf54453cea1f66fcbbd3f1f4f1f8a569adb8d1e2e1849a53" => :el_capitan
    sha256 "0280ceb9ab03a7ffbe150b5fa398f0c649fde1c4af2183938cb6d6420005c3de" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :x11
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
