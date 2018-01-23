class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.6.0.tar.gz"
  sha256 "11515546516b3c54719b6b402cacf46e8d5172450d6e9fe2655b237582490315"

  bottle do
    sha256 "d8fd68f360e83c62b5933323054d688657c58df91a4f10d7986c3124e276f5a4" => :high_sierra
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
