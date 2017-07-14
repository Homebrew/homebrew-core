class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.12.2.tar.xz"
  sha256 "d8ba9264e8ae6e440293328e759e40456f161aa66077b3143dd07581136190b3"

  bottle do
    sha256 "75915b1d856445e13715c50b5d54241f63ef11ded283ecf8448a27ed6de86e19" => :sierra
    sha256 "f2ed51f45157e7b75f027270f2a8a12fc153e32f7228083dafa30003da7edc61" => :el_capitan
    sha256 "0b3f9ce5842204f8f9a066e3d0d15b32c78efc96d96ea0c0835602579a56bc37" => :yosemite
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
