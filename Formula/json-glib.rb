class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.4/json-glib-1.4.4.tar.xz"
  sha256 "720c5f4379513dc11fd97dc75336eb0c0d3338c53128044d9fabec4374f4bc47"
  revision 1

  bottle do
    sha256 "223b5472cc71a1eea8efc818d66fa8e6ff05a4aff45d60d4deccba54f82d39dd" => :mojave
    sha256 "ad30f6f204dd27504d70e9ac22dcfdd482975a5e97879c0b4095527bde68d985" => :high_sierra
    sha256 "08dbbf2bcef7fdeccfbcd7a0391c4eafa67f914ba0f021c8a41298a6359f7c24" => :sierra
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
