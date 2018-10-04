class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.14.4.tar.xz"
  sha256 "18dccca94bdc0bab3cddb07817bd280df7ab4abbec9a83b92620367a22d955c7"

  bottle do
    sha256 "7fbebd2136308b40da746f9c6894a53543ca700ac0a08af7593b7be3e9a8343b" => :mojave
    sha256 "8d0233be95f46cdc71b2f95f87b6522d33b57bf42ba08174066ae5150e2a5a43" => :high_sierra
    sha256 "dbe94ee52258b48770ba1f60b408439cd1b64195f40a4cc698dc39cc61107c66" => :sierra
    sha256 "9ebf5f62391ab54e64a76a4e5dd5d33616288c324fcf922e4837d337658b23cd" => :el_capitan
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
