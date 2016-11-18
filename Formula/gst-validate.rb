class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.10.1.tar.xz"
  sha256 "07ae671a3e77c5480d2c1732175dd3b3255b6937ac55d4b3e69a90f8e3043f75"

  bottle do
    sha256 "da41258ac15979fe16becb2591e0428e92181d39d4a480ed867665f84f76ae8b" => :sierra
    sha256 "86fb4c9d3e08afd130ff1a178aab8ca3410e20bdbcb38c486f2746202bd3c13b" => :el_capitan
    sha256 "56af0c2ad0a07859440b3ecc5a65d2233d54bc55b41dd9c73b146f36a257e103" => :yosemite
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
  depends_on "json-glib"

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
