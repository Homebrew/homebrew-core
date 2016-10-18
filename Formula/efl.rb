class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.18.2.tar.xz"
  sha256 "292faf76557fe56a6bc15b48b5ea3eb1f0790e2ed7f2ade4ae79ef7973d67bed"

  bottle do
    sha256 "fe5856e42d8e14cbc63b37214315e9d2ac68bf239bf4ed088ffccff088222cfc" => :sierra
    sha256 "f72a6c0775cc646a22baa5c19f49eb88258de9dd9fb02ffc7d86df0f5b180de1" => :el_capitan
    sha256 "2c8dd2fe10fe1a194ab3e6b9d50c4d038722036c00c15291c389f22cda2f37a9" => :yosemite
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
