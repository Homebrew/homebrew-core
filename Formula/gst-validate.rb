class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.12.2.tar.xz"
  sha256 "6b7a25d1fd2a08ffe08e4809587f16b4c4e01dfd9e77cfa222b7f2558666fedd"

  bottle do
    sha256 "49d9273ebd3c4c43ffffb3b16f50db82409bc30fe90a7bce3be821672fbf95cb" => :sierra
    sha256 "8d9a58a1a63b5b8c424c332f564684fb6ab696c07cd71c230c764f51fe6d5245" => :el_capitan
    sha256 "3e5f72256f2a4b3b9a4a9857e41dff749100a95cedf85d9c652cafde77d801a5" => :yosemite
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
