class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.16.1.tar.xz"
  sha256 "b0abacad2f86f60d63781d2b24443c5668733e8b08664bbef94124906d700144"

  bottle do
    sha256 "7a433267d032d4b9aa6442667c72e087f48c6d02fbaebc4a4d4be5ec187869a6" => :mojave
    sha256 "d51a7ead1e504a0e69ccc0ab3054c3dee365a81ab2ae3f60a0f7e9c035643afd" => :high_sierra
    sha256 "1b153a152874ea95e22b56a688f771ca794aec212fa81e3ad688ca36dd336a50" => :sierra
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
