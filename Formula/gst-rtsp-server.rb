class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.16.0.tar.xz"
  sha256 "198e9eec1a3e32dc810d3fbf3a714850a22c6288d4a5c8e802c5ff984af03f19"

  bottle do
    sha256 "6e1c3a9e72278a70e1bdb8d433c508e72cc497df0566f798c8fab122cd53bdd2" => :mojave
    sha256 "cb3343decf877ca2919ca699f22fb3c91bbc05470f246f1e73809637f8770360" => :high_sierra
    sha256 "e6524315263aee002d3697c6af2c7d5479ec145764406ea1f0438416f6e5ab81" => :sierra
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
    assert_match /\s#{version.to_s}\s/, output
  end
end
