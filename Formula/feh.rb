class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.6.2.tar.bz2"
  sha256 "1649fb79d1a1242938cd64a468fd2666c8b1174421b1050244f39e01d3c7c634"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "e1d1f215337bc782e22c0be9bab3d21724bc39d5ed7e4e79ed08d409e9c1a862" => :big_sur
    sha256 "0cefe29da27469551f1a0cf47c19217e0b88f65a2d9f8ca23900a4a6abf8b9b7" => :arm64_big_sur
    sha256 "c99b3a9f524feaae060b15d8d5707a95cc73345934d30038726be58519fe7855" => :catalina
    sha256 "2f0068a025b73f6906e7235359cb0aed127ac236db2d89874f1c61e0465c62c3" => :mojave
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
