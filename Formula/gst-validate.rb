class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.10.1.tar.xz"
  sha256 "07ae671a3e77c5480d2c1732175dd3b3255b6937ac55d4b3e69a90f8e3043f75"

  bottle do
    sha256 "0e8a970805eea8eefeda337d406b7f513fcfa4ecad2a6599a3e1df2bd921b2ee" => :sierra
    sha256 "ff77c624a52f2a9f5b92d0c459aa8f7260b9688324b927f89684da957ba28630" => :el_capitan
    sha256 "3abcf1e4debd0aeb0a0ed3da901aa96e7c2676b4726f9df7fae05c8d884bd5c5" => :yosemite
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
