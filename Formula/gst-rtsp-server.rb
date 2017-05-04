class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.12.0.tar.xz"
  sha256 "85ae6bbe173b365ddf4859967144f1999b436531ecbe09935914bfa9f6b37652"

  bottle do
    sha256 "0faf3f63162addc60df3bc70bcf281a511ef1253b760055c417ff9b61bfec2bd" => :sierra
    sha256 "53ede4a9738a7a83c93e9166ae56411fd1ac77d4db4e01d0defe1696e85689f1" => :el_capitan
    sha256 "14e37b7c0f92c4bb9026e7edc02382aa52a51618a932fff92711d82577e97751" => :yosemite
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
