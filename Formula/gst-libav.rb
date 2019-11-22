class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.16.1.tar.xz"
  sha256 "e8a5748ae9a4a7be9696512182ea9ffa6efe0be9b7976916548e9d4381ca61c4"

  bottle do
    cellar :any
    sha256 "ad0c4e8380bbb613610194dc079aea534fc4b0fac7bcd05731fc5a3a1c75e132" => :catalina
    sha256 "c8eb0c950e0af9cd3c1fe0d1200faacf8dc5884afa4fa6dab26d0ce73395f316" => :mojave
    sha256 "34cf7b6dcf57c348ac040185cdf8bc319d229ee4d6449550e23a1e14610e2804" => :high_sierra
    sha256 "44a3bc6c175dcb0c80f607358902fd1870c961e4a846ed2296fac841638ef005" => :sierra
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
