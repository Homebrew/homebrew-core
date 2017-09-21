class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.20.3.tar.xz"
  sha256 "1273014aff3cd313a315f6745b02958668083726d830873b681fe726b9421191"

  bottle do
    rebuild 1
    sha256 "3ced0bcc409e11efaface3353078fe857c01c077a1e7abddb1d1c810d51fa7b1" => :high_sierra
    sha256 "d639d1d08c6b0d7d477010b9f8471ef3751088b6f900614130993928a9a6b4bb" => :sierra
    sha256 "c519189de000ef8c9ee05db7b7ba55c250197225906d9a818b5350428efb3ed3" => :el_capitan
    sha256 "094c644bc242fa28ad3282325cf4a584c41a2c5c07ae9d7a3547859397a9137f" => :yosemite
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
