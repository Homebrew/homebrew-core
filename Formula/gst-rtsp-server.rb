class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.14.4.tar.xz"
  sha256 "3d0ece2afdcd601c175ece24e32a30bc19247b454f4eafd3deeec2533c6884f1"

  bottle do
    sha256 "4f7fe898f0b69c9683adfc57013b86925449a5ff8c23cd87c4e525ba52ddd6e9" => :mojave
    sha256 "d383909854593df9b8580e637729d88bf71a5a3e9fc3ce052251a6e81e0031b9" => :high_sierra
    sha256 "fa70aeaa924d0ea0066e6a3744bfe0c490b93df0a50bda8bd8c523a973dd1f24" => :sierra
    sha256 "6c658459295933a9abd45622b8ea06b82c2d60111517d454ef7b0d93d2f6a092" => :el_capitan
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
