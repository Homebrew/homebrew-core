class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine."
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftp.gnu.org/gnu/freedink/freedink-108.4.tar.gz"
  sha256 "82cfb2e019e78b6849395dc4750662b67087d14f406d004f6d9e39e96a0c8521"

  bottle do
    sha256 "4550fb1f25bc39cfa56fcbcf379ae550d2f38336a2ea2accb8476bac1798aa90" => :sierra
    sha256 "078e167005c6b4a4629b0d8a0c3c93d1f496dd503163c674b843e4c1c6d58642" => :el_capitan
    sha256 "f6c9c620180b22989a2c57a7eca7d75c1e6fb895a62c6f24ff9d7e51b39f50a5" => :yosemite
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
