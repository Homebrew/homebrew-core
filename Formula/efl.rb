class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.20.7.tar.xz"
  sha256 "b0a9b765bcd7b012f1072da1d491fc8671aa089473f746901d93f5807a2c76fe"
  revision 2

  bottle do
    sha256 "528c9b5f0c789f2280a001fee13eecd9392b840e4dd09e4b8cef343b22653cb4" => :high_sierra
    sha256 "c3bd20000e5d3c53a723a3170cefa3687f26d180c1b6261c4d5503c3fbdcb2ae" => :sierra
    sha256 "cfdb61ccb7cdeec28232b24deaeb85196d0e14eb857e047c57ef75c8e1fb319e" => :el_capitan
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
  depends_on "shared-mime-info"
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

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end
