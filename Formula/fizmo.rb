class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.2.tar.gz"
  sha256 "369c3b58e019756229bf7e72cc5b15c049f1d6d5c65d7653267e67cef109e675"
  revision 1

  bottle do
    sha256 "28709b42a9477600b1a86c6dcf1b5d4ba1fcb7b3ad5b76b067664dff15f70f93" => :sierra
    sha256 "81d50ee0f6fe982228513819483a854083be84e100afed382aa7d9d985c4b6a9" => :el_capitan
    sha256 "6d5297ce659d12e2d87a230af7205e09c1d9bd2f7b8e22af4d24db4b9ef1ce13" => :yosemite
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
