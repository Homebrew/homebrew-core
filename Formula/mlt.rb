class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  license "LGPL-2.1"

  stable do
    url "https://github.com/mltframework/mlt/archive/v6.22.0.tar.gz"
    sha256 "3392d70c528d7f32e78329232b1b93a5a36b058215f664953090315132b797e5"

    depends_on "opencv@3"
  end

  bottle do
    sha256 "e81b8558b3d04eabd9d02084cad01278b2f3ae64c37edbbe8c5026983aac829e" => :catalina
    sha256 "59d187ff682eb6e586f2223c79288b1cb8833a306260539bd12adaeeddab562d" => :mojave
    sha256 "a376edfbe8b4d526b52da5df322d0bb6c1c0daaf8caefd57c25d8715d218b388" => :high_sierra
  end

  head do
    url "https://github.com/mltframework/mlt.git"

    depends_on "opencv"
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
  depends_on "pango"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sox"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec",
            "--disable-gtk",
            "--disable-sdl",
            "--enable-motion_est",
            "--enable-gpl",
            "--enable-gpl3",
            "--enable-opencv"]

    args << "--disable-gtk2" if build.stable?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
