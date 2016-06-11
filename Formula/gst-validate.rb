class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.8.2.tar.xz"
  sha256 "33c5b585c5ca1659fe6c09fdf02e45d8132c0d386b405bf527b14ab481a0bafe"

  bottle do
    sha256 "c659a921830e558aa6111416c71efc2e59060c193c306b9a25d396ce18e43d92" => :el_capitan
    sha256 "542df374033a74a928a01a13ea4621ff97940e19444ac95fd8bfeb642f2f47de" => :yosemite
    sha256 "b31a53cfaa7d819fcd2b8febd54e432b37dfe80124f38f5a0aac6b89637135b3" => :mavericks
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
