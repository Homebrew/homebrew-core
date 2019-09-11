class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.16.0.tar.xz"
  sha256 "dfac119043a9cfdcacd7acde77f674ab172cf2537b5812be52f49e9cddc53d9a"
  revision 1

  bottle do
    cellar :any
    sha256 "969c90d0656db2918c2145a448e80ae2208625eac38abd5bd4bdefe38c8f5b74" => :mojave
    sha256 "df7916f16f58397ac58836cb30517f5cdb52dd9f71a7dc14528c845a3be04a92" => :high_sierra
    sha256 "51c7ad3bc047c8261321f6d74ac64cb362e995d96ae55cfc9586bec8980774fc" => :sierra
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
