class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.20.0.tar.gz"
  sha256 "ab211e27c06c0688f9cbe2d74dc0623624ef75ea4f94eea915cdc313196be2dd"

  bottle do
    sha256 "5703d5533277335653085a3beed96f9df7053865b49d069d2d9fc2106550c8f2" => :catalina
    sha256 "3b5dbf20d3443b7695977c5b2e9a8dbdbe1aca98e60f79530ec61dcd01c42ca7" => :mojave
    sha256 "5a16fe520d4e3f3b03178c528dfa2147309af558a3b08bb10f2cc283a59f218c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "fftw" # fft, lightshow, dance
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libexif" # qt module needs libexif
  depends_on "libsamplerate"
  depends_on "libvorbis"
  # mlt >= v6.21.0: depends_on "gdk-pixbuf"
  # mlt >= v6.21.0: depends_on "pango"
  depends_on "opencv@3" # mlt = v6.20.0 - opencv.tracker
  # mlt >= v6.21.0: depends_on "opencv@4" # opencv.tracker
  depends_on "qt" # qtblend, qtext, audiospectrum
  depends_on "sdl2" # Class SDLTranslatorResponder is implemented in both
  depends_on "sox"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-jackrack",
                          "--disable-swfdec",
                          "--disable-gtk",
                          "--disable-sdl", # Don't need SDL because we have SDL2
                          "--enable-motion_est", # audiowaveform
                          "--enable-gpl",
                          "--enable-gpl3",
                          "--enable-opencv", # opencv.tracker
                          "--disable-gtk2" # mlt <= 6.20.0, otherwise <gdk/gdk.h> not found if "gdk-pixbuf"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
