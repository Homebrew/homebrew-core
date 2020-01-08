class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.16.2.tar.xz"
  sha256 "de07a2837b3b04820ce68264a4909f70c221b85dbff0cede7926e9cdbb1dc26e"

  bottle do
    sha256 "30d213fe81eece2d6a566c7d53ea36f9f3ee24219aa7b0be4edf15d46559cc03" => :catalina
    sha256 "fc5d1f94602dc377f2d6938ed5f97e1a104958fbfeb26e48598e18c0dd0ca9ca" => :mojave
    sha256 "94e6f9c451be9c5f2e3b3a92d7450b730b3cea49c85f1e03cd8348943385a311" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

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
    assert_match /\s#{version}\s/, output
  end
end
