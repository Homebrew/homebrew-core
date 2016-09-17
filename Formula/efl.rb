class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.18.1.tar.xz"
  sha256 "0c6bd150d8e838f849effd462d91d86255e3aaade47a6077d0aa80d2b8e9d222"

  bottle do
    sha256 "edf518f51d6ee54d5d4c8dbaa8ea4a3f1c775c2df6abbdc1636a41f8360af8ea" => :sierra
    sha256 "a8e51818234a137bc021469bf37a52c84608d4e399420b71ff360682c8a7a8ae" => :el_capitan
    sha256 "a8fe89f450fc0328f84a442b138a93ebbdd516d03ccfe333e3c21fa080befd7f" => :yosemite
    sha256 "4d1e000d79e426ffaf82e1b4603239b2c629c8eab5549b29d403a2b88eca24f5" => :mavericks
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
