class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine"
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftp.gnu.org/gnu/freedink/freedink-108.4.tar.gz"
  sha256 "82cfb2e019e78b6849395dc4750662b67087d14f406d004f6d9e39e96a0c8521"
  revision 2

  bottle do
    sha256 "a85e4560ea7be49eddfe43af2f23cc3ad71a99c7c8aacf8a50f671af1a81777a" => :high_sierra
    sha256 "7af81b5a0bdcabd11a7fdd705b3c7bbc0a169513ec26a30b5c57ef82dcd45d97" => :sierra
    sha256 "69db51ab48473114449682010dfa7e03c992184a7fea6df1dd4e6c6a6e7ca72a" => :el_capitan
  end

  depends_on "check"
  depends_on "sdl2_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "gettext"
  depends_on "libzip"
  depends_on "fontconfig"
  depends_on "pkg-config" => :build

  resource "freedink-data" do
    url "https://ftp.gnu.org/gnu/freedink/freedink-data-1.08.20170409.tar.gz"
    sha256 "e1f1e23c7846bc74479610a65cc0169906e844c5193f0d83ba69accc54a3bdf5"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
    resource("freedink-data").stage do
      inreplace "Makefile", "xargs -0r", "xargs -0"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    assert_match "GNU FreeDink 108.4", shell_output("#{bin}/freedink -vwis")
    assert FileTest.exists?("#{share}/dink/dink/Dink.dat")
  end
end
