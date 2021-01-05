class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v6.24.0/mlt-6.24.0.tar.gz"
  sha256 "3b977c5632329fca7634d0034162df6d5b79cde3256bac43e7ba8353acced61e"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 "50d28e5c661af49faf660bb7fbae1c5e696b20fc91c087bfe8ffb5a4ce29b528" => :big_sur
    sha256 "5919ce61cb9eab5166aa97695d59c9fad673cf97afad3dcd59f9a0d4ad1ced8c" => :catalina
    sha256 "f28b8247fc5717bc56d79fc646d05310087b0289c22d096a2474c62334e03885" => :mojave
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
