class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.0.tar.xz"
  sha256 "fb134b4d3e054746ef8b922ff157b0c7903d1fdd910708a45add66954da7ef89"
  revision 1

  bottle do
    sha256 "1e3904fbdadae7286f9886191ddd9308bfb7c1bf7212c2d2d7858c216b153c70" => :high_sierra
    sha256 "9ddb05aff2e59a4b5f0a3803e9f75e4172a041f48c6b476201543fff3404a529" => :sierra
    sha256 "9793e29848c59b0543bfdc9d393426f92dfa04b29bdd38b11fefe69f61f005fa" => :el_capitan
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
