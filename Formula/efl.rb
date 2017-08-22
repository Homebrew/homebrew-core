class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.20.2.tar.xz"
  sha256 "a540cb96f0a2a8f2e3001108d8432d2f21b45f6b12bd511eeebaadd5c934947e"

  bottle do
    sha256 "acca70f94bdc9a6723d9c936dff146ee031490b7d5e90900f2e411da375aa86d" => :sierra
    sha256 "74995045ad00dfd7c8e23fd3c34987831167c4dd5c3b8dc7598fcd03bfbabceb" => :el_capitan
    sha256 "826e24d729095ef8c0a011e822dd6004c0def8653d161612f1bd95acadfb6e3e" => :yosemite
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
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end
