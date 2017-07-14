class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.12.2.tar.xz"
  sha256 "5bb735b9bb218b652ae4071ea6f6be8eaae55e9d3233aec2f36b882a27542db3"

  bottle do
    sha256 "cd744615fc559f28f15c8c184afffb611c79295d21054a5b98b0b1b76ca9aa1c" => :sierra
    sha256 "261024a779d6c67dad053080af6f278bf9b0b1b88e4fc87e7ab86f5df39c822f" => :el_capitan
    sha256 "78ed8388cb99cd69fbf19c341f98f868c538ca3829fd2ac59708ed1f8482b952" => :yosemite
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
