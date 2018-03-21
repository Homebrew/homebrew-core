class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.0.tar.xz"
  sha256 "fb134b4d3e054746ef8b922ff157b0c7903d1fdd910708a45add66954da7ef89"
  revision 1

  bottle do
    sha256 "f72597f3334728bccdd33fc5ef969329230c858a346d040c9944ab0580dc2249" => :high_sierra
    sha256 "0b8f8bc2ff2d01bb31e9555584f7da7f30acad873e51e09b38b8cccff18e05f9" => :sierra
    sha256 "b66d111ab85739163806c024636668532395667f282bcd77a8e8475164294b57" => :el_capitan
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
