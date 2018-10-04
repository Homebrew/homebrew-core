class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.4.tar.xz"
  sha256 "dfd78591901df7853eab7e56a86c34a1b03635da0d3d56b89aa577f1897865da"

  bottle do
    sha256 "f86013d906715ac05b25ce1dc23c333e72e08b42efdded5243339fa999d38ea6" => :mojave
    sha256 "71d5d622226f5cc0fab7e261f5567b74d93d674dc55f318540e0283d1d64bcb9" => :high_sierra
    sha256 "5b84f00826297ae6cce01c492290ca6540e232391936e0f5095cc6daca9a6fbb" => :sierra
    sha256 "b28827878ad77ee1568c908e927b7a2b1c90b73a4bf78e3c9bda567dbd7b0087" => :el_capitan
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
