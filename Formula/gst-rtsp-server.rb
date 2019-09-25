class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.16.1.tar.xz"
  sha256 "b0abacad2f86f60d63781d2b24443c5668733e8b08664bbef94124906d700144"

  bottle do
    sha256 "9135b45e87802aea586171dae2099344d9b75b3aa43a0835e4b5141dec6606ab" => :mojave
    sha256 "eead12891fec8bbb9ead6620974e06ded10d5a12247438a1995eaba2d81a0796" => :high_sierra
    sha256 "c48ef0efb71e97c4ccfcc5e04bc586e71e66a2a8b97cfd8712cc90859acd675d" => :sierra
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
