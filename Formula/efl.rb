class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.22.4.tar.xz"
  sha256 "454002b98922f5590048ff523237c41f93d8ab0a76174be167dea0677c879120"
  revision 1

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

  # Apply some idea from https://phab.enlightenment.org/T8562
  patch :p2, :DATA

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

__END__
diff --git a/src/lib/ecore_cocoa/ecore_cocoa_app.m b/src/lib/ecore_cocoa/ecore_cocoa_app.m
index 8df1be1830..939f629ece 100644
--- a/src/lib/ecore_cocoa/ecore_cocoa_app.m
+++ b/src/lib/ecore_cocoa/ecore_cocoa_app.m
@@ -45,7 +45,7 @@ _ecore_cocoa_run_loop_cb(void *data EINA_UNUSED)

 - (void)internalUpdate
 {
-   [_mainMenu update];
+   [[self mainMenu] update];
    // FIXME Will not compile with GNUStep (member is named "_main_menu")
 }

@@ -76,7 +76,7 @@ _ecore_cocoa_run_loop_cb(void *data EINA_UNUSED)
 {
    [self finishLaunching];

-   _running = 1;
+   [self setValue:[NSNumber numberWithShort:1] forKey:@"_running"];
    _expiration = [NSDate distantPast];

    _timer = ecore_timer_add(ECORE_COCOA_MAINLOOP_PERIOD,
