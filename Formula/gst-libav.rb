class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.8.2.tar.xz"
  sha256 "b5f3c7a27b39b5f5c2f0bfd546b0c655020faf6b38d27b64b346c43e5ebf687a"

  bottle do
    sha256 "8efa72ce3a0b9c96e27ac3bf5bd8108063b91bbed9f68cd80ad5c8ae66695222" => :el_capitan
    sha256 "53f643b208dc7931f1b140b29b13e101d7273fc2e4e2c36dd0c4994a9a99fcb0" => :yosemite
    sha256 "7416df575e72ee455140aaa15d4a33ea437f8e5daf889294c5ae5867dd5237b6" => :mavericks
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
