class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v6.24.0/mlt-6.24.0.tar.gz"
  sha256 "3b977c5632329fca7634d0034162df6d5b79cde3256bac43e7ba8353acced61e"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 "e11526070c750b8d4d27a3e7e7e61c74fb17c4bc95624f001876f2d2336bfd37" => :big_sur
    sha256 "b25a49d0d108710e0defe0f8fa8662c5799140bbe0f56810ad9b9ff1652e1f1b" => :catalina
    sha256 "0e14497ab767e5cb89bcc1b8a2f03fe80010dcc275b02c584f4cd6020def3163" => :mojave
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
