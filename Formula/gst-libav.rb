class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.10.4.tar.xz"
  sha256 "6ca0feca75e3d48315e07f20ec37cf6260ed1e9dde58df355febd5016246268b"

  bottle do
    sha256 "7a212f1baae604171eec9bcec870881da8a3019587439619dd8f3eacd51229f8" => :sierra
    sha256 "28928240a4773c8ccf7cc5156fc7aaade75c53eb35576a8c83afc1067f799f74" => :el_capitan
    sha256 "5cacdd4fb0df881cdb48b86a2aacb69d96968ce0e990f1cb5277dc8747c852b7" => :yosemite
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
