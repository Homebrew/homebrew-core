class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.21.0.tar.xz"
  sha256 "7e65be78a537aa67e447b945f01f4ecf9ddfa14d509bf6bbf53a60253ecbae4b"
  revision 1

  bottle do
    sha256 "4eb301261e8368605e3f920168426ce51a989508b6992c85e136390d5ecf1d1e" => :mojave
    sha256 "1633ed5eb89bfab9ee883dc411bde78d50b02171d1b9e3eb885ba3d0881bc9ca" => :high_sierra
    sha256 "d8318b4ece6e3f3f1cea4aead66b2e219be181c6ea8016e1b149d0d695be896a" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "bullet"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "openssl"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end
