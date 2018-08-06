class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.14.2.tar.xz"
  sha256 "f7387755cf6ac5f334d4610f1f5aa7da4ff396a487dd5b789bb707f160222c98"

  bottle do
    sha256 "bc42f7610e13790e829b778f8a9679cad2d9c810d2163b595e10d1f21cef7513" => :high_sierra
    sha256 "62ed2331f3cc48a6727e15ab566c2f4ba9defeccb244c6b6519b1055f87dcefc" => :sierra
    sha256 "3b7206a9f9db8c57051246607ed6fd4669ab902cb33a556f4b40ab0489af007a" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-examples",
                          "--disable-tests",
                          "--enable-introspection=yes"

    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match /\s#{version.to_s}\s/, output
  end
end
