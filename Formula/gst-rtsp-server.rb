class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.12.3.tar.xz"
  sha256 "67255971bb16029a01de66b9f9687f20d8dbf3d3bd75feb48605d0723a7c74ec"

  bottle do
    sha256 "957ed155dbbc66cda1c22fd6ad520b74fb6bc810c4dfa8ac246df8699539672c" => :high_sierra
    sha256 "9987f49b9f2e98a5a56554b9795f38a4154083b6ff8677d19ea5503f1d2b43ec" => :sierra
    sha256 "ec97cd73ce6600d5a975dd00971f348220bb7a0174ebca6256e6eaa77fa53f0f" => :el_capitan
    sha256 "d0d005effac7e47ff7d26db9135da43734bf1a145bea73518b8d090d44cb6ba9" => :yosemite
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
