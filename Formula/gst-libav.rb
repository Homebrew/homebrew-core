class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.4.tar.xz"
  sha256 "dfd78591901df7853eab7e56a86c34a1b03635da0d3d56b89aa577f1897865da"

  bottle do
    sha256 "7da0c15362dbc8607787866ce1334fcdc90a0e190b8e7c343fd98ccd746a8ed1" => :mojave
    sha256 "257523dd7cde6bbb35d798eb85318bfdc24c612dbf9e64c69c77a5253467bd38" => :high_sierra
    sha256 "48b296c2f17ce3e5befaa16fbf429ccfc65fd8c9b7f06060a068b31e7a07a1d0" => :sierra
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
