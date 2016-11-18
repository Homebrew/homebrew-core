class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.10.1.tar.xz"
  sha256 "27b28b8de0e6dff1e3952428e8ed8ba4a12f452f789ac0ae9bbe50f00a5c72c7"

  bottle do
    sha256 "0bfe4c427fd490bdb11171b6affa11d9ad99b29e997aeb8120a5793aabc32f07" => :sierra
    sha256 "4c6ae0574cd2c1918184d1fa9fa3c8e20acd4098cea3d5dd5028bc04c307b668" => :el_capitan
    sha256 "e982f050e3f72bc83c705e9f948a1612b80a96289a6f9df420635c4709aa371c" => :yosemite
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
