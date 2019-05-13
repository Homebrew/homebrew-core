class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.22.2.tar.xz"
  sha256 "1699891f825911622de0aa77fe1140eff7335aba619d2352485e54dcff6b1cd0"
  revision 1

  bottle do
    sha256 "398a7773f3d0c05089ce4283d80bddfabb1401dcc125bb58eb660a84fc44c058" => :mojave
    sha256 "8f2e8f70e99ac21d1ea047af7239a3df8889fea8d24e53afd5bae7cad9fefc59" => :high_sierra
    sha256 "9dd8d5408bcd07cb1efe080075f3f7c79800f1c2c351ba19a627a7d8c1082a84" => :sierra
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
