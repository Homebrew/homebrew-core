class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.18.3.tar.xz"
  sha256 "0748ec0847f543d96b149cb3a84e6438724e827a38d530922ecb4bd59d3e64c0"

  bottle do
    sha256 "fa2be7e2eae7bb4cf1b00fdb5edadd4c28c7751d9cb5e2bc986328491278bb5d" => :sierra
    sha256 "6419d3f0598b07c2c25f60668c84973cd44381c684283ea0c337db3c1e9787bf" => :el_capitan
    sha256 "8562eeb7607545a79914f722d2d3d77f5750860748de77e7580bf11b3449408f" => :yosemite
  end

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "openssl"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "luajit"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "libtiff"
  depends_on "gstreamer"
  depends_on "gst-plugins-good"
  depends_on "dbus"
  depends_on "pulseaudio"
  depends_on "bullet"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "webp" => :optional
  depends_on "glib" => :optional

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --disable-cxx-bindings
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eolian_gen", "-h"
    system bin/"eet", "-V"
  end
end
