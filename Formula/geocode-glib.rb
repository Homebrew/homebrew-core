class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.0.tar.xz"
  sha256 "ea4086b127050250c158beff28dbcdf81a797b3938bb79bbaaecc75e746fbeee"

  bottle do
    sha256 "e5de1d30642132756a9232712a49e4fb3f33ff69c48a010972e199962304e6ac" => :mojave
    sha256 "c8891ae560d3fe57484495de4f23c2176916b706aa3ba06374fdbe055615ae23" => :high_sierra
    sha256 "c990bec6c31df35bb6abed2bd5f0fbdf6101144a37461b4c0143b93bdf00ff36" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  # macOS linker does not support --version-script
  # see https://gitlab.gnome.org/GNOME/geocode-glib/issues/4
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Denable-installed-tests=false", "-Denable-gtk-doc=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/gnome"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/geocode-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgeocode-glib
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/geocode-glib/meson.build b/geocode-glib/meson.build
index 8bc2bfc..fdb94bc 100644
--- a/geocode-glib/meson.build
+++ b/geocode-glib/meson.build
@@ -49,7 +49,6 @@ libgcglib = shared_library('geocode-glib',
                            dependencies: deps,
                            include_directories: include,
                            link_depends: gclib_map,
-                           link_args: [ '-Wl,--version-script,' + gclib_map ],
                            soversion: '0',
                            version: '0.0.0',
                            install: true)
