class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.12.3.tar.xz"
  sha256 "67255971bb16029a01de66b9f9687f20d8dbf3d3bd75feb48605d0723a7c74ec"

  bottle do
    sha256 "812cd822fb271c41e5f88345c74202502987f219519c40d97bbfba626160c790" => :high_sierra
    sha256 "6944dc338ddaec7b88844472064f525ac1697bc306c6e1567b93be3c8d4a60d0" => :sierra
    sha256 "2a1ed7adc57a565e9a423e8e9694d5e650cc65364c84ca01e183396d53c79e80" => :el_capitan
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
