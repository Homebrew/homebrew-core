class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.21.1.tar.xz"
  sha256 "44774b42b3dbbbe4d124c8fddcd169c6ffab9d602d1a757abcfb9a84e001a928"

  bottle do
    sha256 "c375e6393bae92eec424b04a75e4489138631f7d471d2ab9d5be6985ea71930a" => :mojave
    sha256 "b8a43e0d6f257cf0b0b8a75f4ef74754278f4a676f361ca962fcf83d44cdb3bf" => :high_sierra
    sha256 "7f08d6c68ee94bb493aad13cff217f3cd3ca2e29384826146737cfa7b4b6a727" => :sierra
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
