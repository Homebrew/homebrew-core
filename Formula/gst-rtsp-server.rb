class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.14.0.tar.xz"
  sha256 "6b65a077bed815f6d3157ebea503cc9f3c32d289af2756b7ff7e3958744d9756"
  revision 1

  bottle do
    sha256 "eed082877b8ed362e14d9fc0acc25988fd6e11991f3893f7937c62015636a9cd" => :high_sierra
    sha256 "81498d439ec1c160055c71ca088077245de508e11c325d5f54648350745df46a" => :sierra
    sha256 "406f5450588bc7afedb525eac961d64b630145359d92cfdb59e353e46e7edc96" => :el_capitan
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
