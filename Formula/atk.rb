class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.30/atk-2.30.0.tar.xz"
  sha256 "dd4d90d4217f2a0c1fee708a555596c2c19d26fef0952e1ead1938ab632c027b"

  bottle do
    sha256 "ef98c860ad49b7c335854dc8a558e193353a8afad8d22d0bc1be1d82ccc716c7" => :mojave
    sha256 "13a414fd51dc409c7fb66ff5a91920f11cda4a18e311b16249df7a1395e8f2b5" => :high_sierra
    sha256 "945bbdb2a8e1ed4802a9b437fcdfccd59d0de099bcbee66e32a42f7cf9c86896" => :sierra
    sha256 "786efff084a599afbdc9ab706da2e64ae1c4fc29110ab8f7379649a9651599e2" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  patch :DATA

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/atk-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -latk-1.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index 59abf5e..7af4f12 100644
--- a/meson.build
+++ b/meson.build
@@ -73,11 +73,6 @@ if host_machine.system() == 'linux'
   common_ldflags += cc.get_supported_link_arguments(test_ldflags)
 endif

-# Maintain compatibility with autotools on macOS
-if host_machine.system() == 'darwin'
-  common_ldflags += [ '-compatibility_version 1', '-current_version 1.0', ]
-endif
-
 # Functions
 checked_funcs = [
   'bind_textdomain_codeset',
