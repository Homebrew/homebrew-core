class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.14.1.tar.xz"
  sha256 "38634f3b25c2bf2967b1ff914b54ff384f8612f5aefc18accd72c78bf3b02d7c"

  bottle do
    sha256 "8685967d5691dd7bd63981eee80a0780d4daaabe650f4c07f1498e4694875dac" => :high_sierra
    sha256 "45d3f693b64f0041fc923135e7e0ccb1f80bb8784e508fa25b43c6e53318bbb6" => :sierra
    sha256 "af95008a046a4a95f90a8fe3c2c51a7e14623be12463e61da681835e1f5fe01c" => :el_capitan
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
