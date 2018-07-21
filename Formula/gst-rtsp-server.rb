class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.14.2.tar.xz"
  sha256 "f7387755cf6ac5f334d4610f1f5aa7da4ff396a487dd5b789bb707f160222c98"

  bottle do
    sha256 "ba6adc517952ea63aca9f133314fa50649dbb530b3b6412856177aefe26f9baf" => :high_sierra
    sha256 "5f63f82f821521680430e203a0bd4dd4b753d4eb617eef502a0b2c3714848ac7" => :sierra
    sha256 "b6f5765f6565d1913dfd791036a48a8b61dc0c50bb3ffdf7b7b610de6b5527ac" => :el_capitan
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
