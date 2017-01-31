class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.10.3.tar.xz"
  sha256 "baf9f7d229711cb3d823a447a930132f809b3321eab3535491bb01c8a21566fe"

  bottle do
    sha256 "380360474051414dd8fa98056b65b37a238457cffdf453939f395e6b1c8057d3" => :sierra
    sha256 "53dea0556dc1dc6e6324a736ee40580c2dc671ed7424734bfeae52204693e165" => :el_capitan
    sha256 "52ff8d5fc2be57ddc3752145ef31ae53677df7d7e83bb048758da0b86158d838" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "gobject-introspection"

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
