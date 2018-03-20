class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.14.0.tar.xz"
  sha256 "33df08bf77f2895d64b7e8a957de3b930b4da0a8edabfbefcff2eab027eeffdf"
  revision 1

  bottle do
    sha256 "526557d6f86ddebd6b703a5a0ce02bc6a41e9604429d32a484b5325006bec290" => :high_sierra
    sha256 "405ef04350157cd26ee182db55d11f59c10a006603335709780954662b215eb3" => :sierra
    sha256 "784750807c6a46d57868b1174d6f9bc9b0b1cf1f8d49934a524a48aff55e9410" => :el_capitan
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
