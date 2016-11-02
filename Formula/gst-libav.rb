class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.10.0.tar.xz"
  sha256 "af98204411c78abb98233c1858f2886be6401304d24be218752bbbcede9bd85b"

  bottle do
    sha256 "8096e64628f7c99a5687ae07559c01f43dcab49dec064e63620c3180be74abe0" => :sierra
    sha256 "70ae4c01f08528601200a7aba4d85041c04c572624ce9943f8709172c97f6db8" => :el_capitan
    sha256 "974e9469592720e7808433386002c2792a18119db21481fd981c2355fabadab4" => :yosemite
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
