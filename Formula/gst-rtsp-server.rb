class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.14.4.tar.xz"
  sha256 "3d0ece2afdcd601c175ece24e32a30bc19247b454f4eafd3deeec2533c6884f1"

  bottle do
    sha256 "58b5e803e53db9f5bee22cc20f978b85b2ed21c6a904c4d29da39e1c8886daf9" => :mojave
    sha256 "b9fd00ac79f679527035b11daa97acbc2a4f72aab4ccbd96e74c55b214160b98" => :high_sierra
    sha256 "40d8e0ec8df9ca5b13966d5ab8015681b21782fe1eb32bb4eed96ad5919bd87f" => :sierra
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
