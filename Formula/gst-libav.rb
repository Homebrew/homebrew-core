class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.2.tar.xz"
  sha256 "8a351c39c5cfc2bbd31ca434ec4a290a730a26efbdea962fdd8306dce5c576de"

  bottle do
    sha256 "de3fedcd2025f2c50cc1f77b8c056dab48d8daf6362aff332e69b5f0afab8a3f" => :high_sierra
    sha256 "11464cc32952ed9fd9a07ef8e72110bf493bddf5f8c9fc9ce515a94a1da47904" => :sierra
    sha256 "5ba6ba3e6df6deb610627da38ec1d1cd84d66f487966b5fbf65836304c28ff73" => :el_capitan
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
