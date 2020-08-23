class GstValidate < Formula
  include Language::Python::Shebang

  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.16.2.tar.xz"
  sha256 "4861ccb9326200e74d98007e316b387d48dd49f072e0b78cb9d3303fdecfeeca"
  revision 1

  bottle do
    sha256 "44ac302a258e77061adf3b5e87542ef2c2d1e6a4399554198f8e54c16a501491" => :catalina
    sha256 "602b5e8cfc4749ead0dba6866b12487742488de6cc59555758284c1c8bc9f4b0" => :mojave
    sha256 "675669b40f30a05ab4c4c32bb92245753890419a8d4f5a649efc9441d200ed28" => :high_sierra
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
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "json-glib"
  depends_on "python@3.8"

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

    rewrite_shebang detected_python_shebang, bin/"gst-validate-launcher"
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end
