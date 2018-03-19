class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.14.0.tar.xz"
  sha256 "33df08bf77f2895d64b7e8a957de3b930b4da0a8edabfbefcff2eab027eeffdf"
  revision 1

  bottle do
    sha256 "c272836c10d8688d8fdfbd660f8a04e87ab796b088cbbee5d803ed9b11e7d2f0" => :high_sierra
    sha256 "08dc1bdd726ea7e63979afedeea2683914ea0fe078cf941f2d4aa9909e68305b" => :sierra
    sha256 "867ac9572fe3db7f985e69eb926f73e1d32be863213e82b155d2c71f1d97035a" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "json-glib"

  def install
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
