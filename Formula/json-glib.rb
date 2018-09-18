class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.4/json-glib-1.4.4.tar.xz"
  sha256 "720c5f4379513dc11fd97dc75336eb0c0d3338c53128044d9fabec4374f4bc47"

  bottle do
    sha256 "5955c4e1bb25115e61252ef5b11e6a4c7e2211b4ff71c56cae5a76c6a73c5064" => :mojave
    sha256 "896582a3d39376e8ae3ed1093344f5de02505d81d4639d6256db8d4f292a24ce" => :high_sierra
    sha256 "ac347ffca088d57e22296de1b717dd0d21086e09b04d20919f530c3a20f4a3dd" => :sierra
    sha256 "19690e86594be958118eddeb8a50cfd8175c00e122bc83120cfefd9914dd1eea" => :el_capitan
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
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/json-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index cee6389..50808cf 100644
--- a/meson.build
+++ b/meson.build
@@ -145,14 +145,6 @@ if host_system == 'linux'
   endforeach
 endif

-# Maintain compatibility with autotools
-if host_system == 'darwin'
-  common_ldflags += [
-    '-compatibility_version 1',
-    '-current_version @0@.@1@'.format(json_binary_age - json_interface_age, json_interface_age),
-  ]
-endif
-
 root_dir = include_directories('.')

 gnome = import('gnome')
