class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.4.1.tar.gz"
  sha256 "87583af552695b2235f4ee3fc1e645d69e31702b109331d7e8785fb180cfa382"

  bottle do
    sha256 "0f48ee12e037716c9a5ef2d6349a3fa205d646a8275ee0c7f9dd0ffdd8c0f6be" => :sierra
    sha256 "0b0fd8855c2c3f02504d182aa95878f310bae9a12558da8b46614e24b6d6fdc4" => :el_capitan
    sha256 "967717d68301e59bf269f48ca9af1b08773517ade99e55683ef62e994398c441" => :yosemite
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
