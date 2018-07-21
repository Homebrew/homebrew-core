class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.2.tar.xz"
  sha256 "8a351c39c5cfc2bbd31ca434ec4a290a730a26efbdea962fdd8306dce5c576de"

  bottle do
    sha256 "90f2990a8c9043fbdc4b63506f1920043a9ebc7b1e25c6f1577d761c36de954c" => :high_sierra
    sha256 "607b6ca6441cf35e6b6ea47b33868414cdb98b4c96b98b479ef185fa9abe907c" => :sierra
    sha256 "c16a148667111e72fb18bf6eb351f2b37870decbcb8494212d259a19be612135" => :el_capitan
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
