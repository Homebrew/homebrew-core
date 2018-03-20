class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.0.tar.xz"
  sha256 "fb134b4d3e054746ef8b922ff157b0c7903d1fdd910708a45add66954da7ef89"

  bottle do
    sha256 "096d30103b5dda4a71c8e382bacea6e8cd11f3a0f365f44ccb13c0818c8170ae" => :high_sierra
    sha256 "373291911b7504b4a5579c482ffe25f832da2f6d414f2f76e058524581c72043" => :sierra
    sha256 "9e6949f43141b323b6e8f2cb5c9e980cda08e3297d688b4a8b9321da427afeec" => :el_capitan
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
