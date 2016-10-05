class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.8.3.tar.xz"
  sha256 "4525a4fb5b85b8a49674e00d652bee9ac62c56241c148abbff23efa50a224e34"

  bottle do
    sha256 "c9599931fcbf3629e832985ecf2dd0b575bfb8aadfd1c538eef3e5431b42044e" => :sierra
    sha256 "aed55a8af38365d479f619310d8b37ff6905ff405c26347b762d50a86ac9eadd" => :el_capitan
    sha256 "be7b23fb25023e0b00d9739fd2604b48c585e97f6daebb1728bb893e93be6079" => :yosemite
    sha256 "d98717452ac0117a136dbc5b6f46916d6415286cb8b9c0d6a484836b86c9977a" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  def install
    inreplace "tools/gst-validate-launcher.in", "env python2", "env python"

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      cd "validate" do
        system "./autogen.sh"
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    else
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end
