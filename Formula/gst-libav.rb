class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.8.2.tar.xz"
  sha256 "b5f3c7a27b39b5f5c2f0bfd546b0c655020faf6b38d27b64b346c43e5ebf687a"

  bottle do
    sha256 "bee838b91f4f275a1ed5a42338217ca8220a49e1d6452240fa445466742587ad" => :el_capitan
    sha256 "0885f86ea9b76c6c63858b8119c85e992ae26eea92aad512d7b40eb6671cf06e" => :yosemite
    sha256 "d7f0ce837f63e3eef73e092aa3d38e38b39d080ab277d87ed9d853f02b7b0a01" => :mavericks
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
