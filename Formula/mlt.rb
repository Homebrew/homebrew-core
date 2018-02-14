class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.6.0.tar.gz"
  sha256 "11515546516b3c54719b6b402cacf46e8d5172450d6e9fe2655b237582490315"

  bottle do
    sha256 "be45b8ddd63ac480058581c5c79dd4a1860a6bf8574c40560458ebe0b3477625" => :high_sierra
    sha256 "3996449d69751983dd01f0367d4843d496bfc46d76d4a9d190f499fbbbb0e612" => :sierra
    sha256 "00600cc103b87b00591ebb1ba3622cc4c2df401033b18ad941694261f61b11c3" => :el_capitan
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
