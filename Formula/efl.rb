class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.18.4.tar.xz"
  sha256 "39ebc07e37437d6ecdeb0f645783484e28a882b38f7e619ad12c2bf9b5548025"
  revision 1

  bottle do
    sha256 "8fd98384e2cfc41afb1b9556d3948c90f069d91185c85e63116757ea9fd6daab" => :sierra
    sha256 "009e3c4c3c4c2a30aff68f8f93ad5f60d1a8389da45e9eaac41f8c92cc05a472" => :el_capitan
    sha256 "3274109f86407842590ce01901cabedbed0e59645bdd23a089121ab787ab19b7" => :yosemite
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
