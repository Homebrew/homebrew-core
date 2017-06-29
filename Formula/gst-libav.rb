class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.12.0.tar.xz"
  sha256 "39d1477f642ee980b008e78d716b16801eec9a6e5958c5a6cdc0cb04ab0750c4"

  bottle do
    sha256 "8b87c592e99c7f553f1e78fb257ecc34e2d022d5cdec86e230c2d9ac1e77a1dc" => :sierra
    sha256 "4454725db16909a32ab8d7e1fccd01c36ef2634c9e0374be6be41f0b29d15429" => :el_capitan
    sha256 "a858d580abf155e321a1cf1d1f64eeb87e633ef15b1ffe098cd8594d22bdb66f" => :yosemite
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
