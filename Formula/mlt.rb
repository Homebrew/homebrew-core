class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v6.24.0/mlt-6.24.0.tar.gz"
  sha256 "3b977c5632329fca7634d0034162df6d5b79cde3256bac43e7ba8353acced61e"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 "6009bac52fe24d7179c1568615853b166f86c30ac9cf6253ddbd596331ac1798" => :big_sur
    sha256 "794d6664650f0c5215c8b22af27c26aafdfbd5665dc198f0defc12a1c869c5ef" => :catalina
    sha256 "3d2e1ff77fba374f3b57b6e7022001fad3d294ba34ff319440c81fba01a93d56" => :mojave
    sha256 "1b7ac52ac214cd75f5da3a91cdb4d3f8d35d451c2bb612dd2ae61a2c15274baf" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sox"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec",
            "--disable-sdl",
            "--enable-motion_est",
            "--enable-gpl",
            "--enable-gpl3",
            "--enable-opencv"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "help", shell_output("#{bin}/melt -help")
  end
end
