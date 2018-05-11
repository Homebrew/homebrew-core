class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.8.0.tar.gz"
  sha256 "b348e7a14d289087a99b077480a28dace519f665af9654676b7f5e713d56f0fe"

  bottle do
    sha256 "b1f89795c12c4af477f514100b25c021b3eeddcb4a9d1440652aa81d31fad8e0" => :high_sierra
    sha256 "5b78782553a55cd0b71f0eaeef217e2196e0b96d843b46caa897338cb5ab92d4" => :sierra
    sha256 "abad78f9330e73451910521f401cbf44c6f60822f9f3ad2f51ce865b0d1a2a6c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "sox"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-jackrack",
                          "--disable-swfdec",
                          "--disable-gtk",
                          "--enable-gpl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
