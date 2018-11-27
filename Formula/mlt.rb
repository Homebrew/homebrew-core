class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.12.0.tar.gz"
  sha256 "a4af6245f0d78f9b5d4bfdfd632d7f6a8a81e47c6eb7184fb1c040db747607ac"

  bottle do
    sha256 "95447989ab9a42f3ec619898f702b6a580c567b8f65633177791dbf8e8c25146" => :mojave
    sha256 "249a61487cc0919a10130b69ec553b6797805ab9331a3007539de5f02352e87c" => :high_sierra
    sha256 "db50798e427fae22e98397ff84b4cefcb27013216a5ab7a4034f7d6e969baf51" => :sierra
    sha256 "afba62350675c658f827709a001f056f57146f818031e433b22c07489da8cf6d" => :el_capitan
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
