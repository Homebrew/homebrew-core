class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v6.26.1/mlt-6.26.1.tar.gz"
  sha256 "8a484bbbf51f33e25312757531f3ad2ce20607149d20fcfcb40a3c1e60b20b4e"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 big_sur:  "25813b8268445f3776c439d80edc2ef23728237978ed0823cc5b6369f45ad68b"
    sha256 catalina: "b3ee3bb7bad07c158d2cccbb5d4629489a4360a58bf0a161a1557745a43f5b57"
    sha256 mojave:   "6b9b14a33bc1022aed3c57c4553bb106c0de72190ec261cba41a3ef7b62be459"
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
  depends_on "opencv@3"
  depends_on "pango"
  depends_on "qt@5"
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
