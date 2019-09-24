class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.16.1.tar.xz"
  sha256 "4bf913b2ca5195ac3b53b5e3ade2dc7c45d2258507552ddc850c5fa425968a1d"

  bottle do
    rebuild 1
    sha256 "d61a54c074e563f514f059689458d42929d6ffd19792d53cc1e02944dc4c9c86" => :mojave
    sha256 "3fb3fe752386d5ac0aad12fdaaa7f28bba2637c32407a382fccc569cb03433ce" => :high_sierra
    sha256 "800581491a681c457a5be6046c3d3d8965cfbbe93e74deccd8523a5381c85e06" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --disable-amrnb
      --disable-amrwb
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
  end
end
