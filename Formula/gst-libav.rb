class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.10.0.tar.xz"
  sha256 "af98204411c78abb98233c1858f2886be6401304d24be218752bbbcede9bd85b"

  bottle do
    sha256 "ccfc57d888baaa6cbed27a510d2398fad16b63536747c0d614045555635afb7c" => :sierra
    sha256 "3eecda264d064400903221f6777d02df615cf6e1e370d10a6d462fad412cd8a0" => :el_capitan
    sha256 "c3f4bdeae2c744e421575a5a89aeef3b844f2e07aa63247438aee326ebe6a45f" => :yosemite
    sha256 "0ade8656b366a7d57949b29b4ba5c2ddaa62dfada4af3595066f513109218344" => :mavericks
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
