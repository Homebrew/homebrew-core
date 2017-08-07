class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.2.tar.gz"
  sha256 "369c3b58e019756229bf7e72cc5b15c049f1d6d5c65d7653267e67cef109e675"
  revision 1

  bottle do
    sha256 "069909413fbd1df59ced112cded0166ccdd8303b4a7fc7b333459e2a047bc5ff" => :sierra
    sha256 "5750e2522754a6e9e051364e35b00909bb1f78951d7e7548f3c9bbe29bf83409" => :el_capitan
    sha256 "fe6e54e32badf6f464e30aed4ffe76aee006fd901d210c954562dafc7df90b04" => :yosemite
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
