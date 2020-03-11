class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.22.4.tar.xz"
  sha256 "454002b98922f5590048ff523237c41f93d8ab0a76174be167dea0677c879120"

  bottle do
    sha256 "d04b2c44f519e791014658b0994f49eee9940ca684ea2de402923bea23db4adc" => :mojave
    sha256 "6d222b36c6172b11ad731ca15481c31a46ad38544ffed22d0d0a778861e63e85" => :high_sierra
    sha256 "5e303d498b339b5c248e9167efd68c362013d9198fdf5dbed98138721688a8db" => :sierra
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
  depends_on "openssl@1.1"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  # Fix build with 10.15+ SDK
  patch do
    url "https://github.com/Enlightenment/efl/commit/51e4bcc32c8b3d20980dd4f669e92e32a95a82fb.patch?full_index=1"
    sha256 "173f15e9154f76898ce090211a7c87675d9198a79a32c7ef59df870cfafea02c"
  end

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
