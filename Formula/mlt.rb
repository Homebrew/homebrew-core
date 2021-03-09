class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v6.24.0/mlt-6.24.0.tar.gz"
  sha256 "3b977c5632329fca7634d0034162df6d5b79cde3256bac43e7ba8353acced61e"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 big_sur:  "768152c19d7f31edf5e3c1ed2a3e8f687d8bf655bb6b9877b0bc3cdf4aadb92d"
    sha256 catalina: "3dfeb31325eaa6dc6665be06488a4edfa0a89b77b9b4390f3b18ac9842d06250"
    sha256 mojave:   "a6eec67fd8692b5abef46cea80f2fd8396bae6799bcf63607c3006685e665892"
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
