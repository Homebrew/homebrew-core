class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.21.0.tar.xz"
  sha256 "7e65be78a537aa67e447b945f01f4ecf9ddfa14d509bf6bbf53a60253ecbae4b"
  revision 1

  bottle do
    rebuild 1
    sha256 "402615004f916c4bce4ea9c861f591fe31975fe894c56e00840adf74c726cb21" => :mojave
    sha256 "983569d3063cdbe45059c119bcd7f82bbc4a73412f2600435420191ce6b218ad" => :high_sierra
    sha256 "035342390bc34cec44f89cd056618ffad4212152f3d23d20d074b8bb1f9ea0d4" => :sierra
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
