class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.4.0.tar.gz"
  sha256 "19d53992385f767cb174d692e577c4cb988d032704dbe3df4ebe6373ed388bb9"

  bottle do
    sha256 "fdedc1c1b5433e31218fdb2c935447c250657bc06f1a8fa8a1ffc0d774e939e2" => :sierra
    sha256 "6b15f3754d873cab13cd61f39d96c191e2427da4d81e7fadc1cefa020e079f48" => :el_capitan
    sha256 "d602a5ffa91f6a7f61c08c0f7d418a131d5038ceb33b035ef462afdd0b328601" => :yosemite
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
