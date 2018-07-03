class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.10.0.tar.gz"
  sha256 "e794f12b00d1b90009a1574237823a03ce0b3625638306d1369888375e90edff"

  bottle do
    sha256 "10ff5e4119eca6470573f82c30e8f16b71dd061cbf6c0d4229dffbea214a9753" => :high_sierra
    sha256 "9838979d2e3f96459b6cfcd4c73428997bbca15485e5c95ed57594970ec2f326" => :sierra
    sha256 "0ed5c3cb424ea0333fccb47bc5f7d18ff8f7e0a14412560450a94f5ac81cd828" => :el_capitan
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
