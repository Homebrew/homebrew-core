class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.22.2.tar.xz"
  sha256 "1699891f825911622de0aa77fe1140eff7335aba619d2352485e54dcff6b1cd0"
  revision 1

  bottle do
    sha256 "bad79e4393b81d6e8deff2dcc94922cb2620860d79b82f4fe620d8c40cf5ef3e" => :mojave
    sha256 "4528b32ab713edcb91b84847d7be635e8525f696a1f87f80b0d6f744cbc405bf" => :high_sierra
    sha256 "30d0383b26b0e616fa2fd7820d135310cb4d52ad024a79645d6f9b255eba152b" => :sierra
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
