class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.16.2.tar.xz"
  sha256 "c724f612700c15a933c7356fbeabb0bb9571fb5538f8b1b54d4d2d94188deef2"
  license "GPL-2.0"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "dce5e4261059fa2fc2e14eb4db2f43cfdf749eee11140539b3f1c3c74af25198" => :catalina
    sha256 "999e32d952de88b5578a3906fe922b135827738ac9b16afcd542bc9ba01d2d21" => :mojave
    sha256 "281dc5fd5d4a0f558b653d7054303fbd30308feb73d2c4e37811d8389d28b6ad" => :high_sierra
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
