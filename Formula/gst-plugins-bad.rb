class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.16.0.tar.xz"
  sha256 "22139de35626ada6090bdfa3423b27b7fc15a0198331d25c95e6b12cb1072b05"
  revision 4

  bottle do
    rebuild 1
    sha256 "f30e77a4b1c12ded28e03b5f81872851a2eae39ffaa0bdc7bde18eb57a9ff14b" => :mojave
    sha256 "d05e4f98f79be7ce023ae6fe9c0fbdd7d0cd23f70dd9c6db382e3539a125e17d" => :high_sierra
    sha256 "df79f8536dd67412947a56fec82d95df9acdc3f844d1a3fc8d582e2bf9a83559" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "faad2"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libnice"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "orc"
  depends_on "srtp"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-examples
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=yes
    ]

    if build.head?
      # autogen is invoked in "stable" build because we patch configure.ac
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
