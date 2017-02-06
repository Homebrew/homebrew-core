class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.2.tar.gz"
  sha256 "369c3b58e019756229bf7e72cc5b15c049f1d6d5c65d7653267e67cef109e675"

  bottle do
    sha256 "6508c97c7c80feeb2585a1ea483401ad893d2d99d27fbd9bae4c032c320b7a9f" => :el_capitan
    sha256 "f054eccbe7d03c18ae2d7d8c8829a006dce5958b3d605c507219d2bf95d9536e" => :yosemite
    sha256 "8e94594cf572ea84b187657ef9ff1f58426e8f3b79aecf53ecb309022c15b2a3" => :mavericks
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
