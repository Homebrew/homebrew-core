class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.18.1.tar.xz"
  sha256 "10a82865c3d199e66731017ca4b120bad071df9889e60cfe4dd6c49d953ef754"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "3462ebd329521219614d45b0352a9652a1b0fa39dd324e7db34e16fec53944a5" => :big_sur
    sha256 "bebc6bb966e159c63bcdeef33a46f7b0b0bda2c1b212f756ad35fd3ed189d455" => :catalina
    sha256 "090b011ee9ff0775820ef3a715f1969941201a2a682af7a6dd87ef06d0c4f744" => :mojave
    sha256 "52cfabf11f79fb08777b838dd38f2d0e36a8c0146f1f9ea855551533e87b8c0d" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dexamples=disabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match /\s#{version}\s/, output
  end
end
