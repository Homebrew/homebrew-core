class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.12.0.tar.gz"
  sha256 "a4af6245f0d78f9b5d4bfdfd632d7f6a8a81e47c6eb7184fb1c040db747607ac"

  bottle do
    sha256 "e24add977a2c3467ff78da442f08f92f98dfc086d874cc15480d48bd942fb403" => :mojave
    sha256 "64d3551e8e755c64639bc61b96a621381b215bfbe0903ed87a87898cbc8996f2" => :high_sierra
    sha256 "5dd285f824a761371eee58c03f285e7625d8ed7ec23f942934b30b574531188c" => :sierra
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
