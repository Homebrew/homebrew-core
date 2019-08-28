class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.22.3.tar.xz"
  sha256 "7e7a4199b1e90d400dab2491db6032f8e0b26bab65ec19c9f8a97a82394331c8"

  bottle do
    sha256 "cc41782d191ea7e577fe4995866554f34830d84fde096a855596370c55e5e829" => :mojave
    sha256 "d9abaa7b1d116bfe2e7e2447b525dbc8525ac15ef4f067c0c33b21970419cc8c" => :high_sierra
    sha256 "ba1bc31c67edc971b9a81e99db98e4ddda8455bf215984c81f3545bc731e4c7e" => :sierra
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
