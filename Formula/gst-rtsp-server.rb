class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.10.3.tar.xz"
  sha256 "baf9f7d229711cb3d823a447a930132f809b3321eab3535491bb01c8a21566fe"

  bottle do
    sha256 "4e2c79e885bd6db446bf41aba445fbeae42a81511ab117c5dbc2a870f67a9eb0" => :sierra
    sha256 "60252ddfa454c7756dee5c6c31bc6b8309fe3aa337aeec8f834c48dff707e88c" => :el_capitan
    sha256 "cb2c6b4fff36343be07c6fb6e3a16b8cee846e7d4d6bc46b1687ad97b9af4cff" => :yosemite
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
