class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.20.0.tar.gz"
  sha256 "ab211e27c06c0688f9cbe2d74dc0623624ef75ea4f94eea915cdc313196be2dd"

  bottle do
    sha256 "a5edb6d726441d05ea1c7f1db7f49739ce6f4305e6227b3a0a5a8d7757f2a092" => :catalina
    sha256 "ecd5481375de9153bac1acd8a6811639d5bab2afb30fdf4b801db8c334a8eec0" => :mojave
    sha256 "16921107de0a40396aa5105174989890acee5f4853f6ca6d6de3f045d80177d1" => :high_sierra
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
