class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.12.3.tar.xz"
  sha256 "015ef8cab6f7fb87c8fb42642486423eff3b6e6a6bccdcd6a189f436a3619650"

  bottle do
    sha256 "1794d7010ffa418721df82d61a5d1615c36f21d3739744152afc0cab681c7abb" => :high_sierra
    sha256 "93d3ab6990f51dcb32c34f2fad63d264ae36a09cfa4523de1727c68f2019e246" => :sierra
    sha256 "90b650c07570fa1eef562e69c1d100798e02556605498fdcd923ffe5190605c1" => :el_capitan
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
