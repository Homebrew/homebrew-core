class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.12.2.tar.xz"
  sha256 "6b7a25d1fd2a08ffe08e4809587f16b4c4e01dfd9e77cfa222b7f2558666fedd"

  bottle do
    sha256 "b33816f8f7320ed4fae1f8a3a17dca666722462c026db3455f87a98bb9bf1270" => :sierra
    sha256 "a758067accd54c13af699d3f89160422e42ea492cde1ae6a2fd25abfa0f32b2e" => :el_capitan
    sha256 "b1e421e7f8cf6bc72be8027458e090606acd7f42bed5ab901d938f24cdc1b13e" => :yosemite
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
