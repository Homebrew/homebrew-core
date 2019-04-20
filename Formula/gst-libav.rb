class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.16.0.tar.xz"
  sha256 "dfac119043a9cfdcacd7acde77f674ab172cf2537b5812be52f49e9cddc53d9a"

  bottle do
    cellar :any
    sha256 "26d30fd768a52b9b6a3457e9fc7ce2e35b2ec2a27f964cc8779571da45d000b6" => :mojave
    sha256 "f325110a27be402f5ceed2d8cb97e65f9fcabb416de76c963bd1117a39c8e58d" => :high_sierra
    sha256 "03b43b9dca807383104fdbecbc2b8a56a58a559b5f5187f453a907a64269d4f1" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-libav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
