class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.10.2.tar.xz"
  sha256 "a3dd7036211f061e1eda04f985b7a9dd1a91b754f767ff2587eb6ec28f44e73c"

  bottle do
    sha256 "c0691cde027e2726aabe54b272a2544a10883cadb56e916971e60d89fc9d95fd" => :sierra
    sha256 "048c9f2b28882e4fe1c429893e03d414f07284887a19857bafbb82312007f424" => :el_capitan
    sha256 "fff6838f79daac7bc9d1398b7e38f42fff2f0672005c67e7e6f5e663d5d5308a" => :yosemite
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
