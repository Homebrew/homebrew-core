class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.26/atk-2.26.1.tar.xz"
  sha256 "ef00ff6b83851dddc8db38b4d9faeffb99572ba150b0664ee02e46f015ea97cb"
  revision 1

  bottle do
    sha256 "08bf533625443e9f7e47c08d163fcc74fcc973c6aae9b61b6ef1a09d506d6a3b" => :high_sierra
    sha256 "cce0be459801eb065dd540baee6aec81740895e46f422722f23c9bfb3dd0a1ff" => :sierra
    sha256 "40860eef1dacca8db3f7de7b1c2aa302e352ea6cd9f05a3ab84234b77bcf6b1c" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  patch :DATA

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "test"
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
index 7d5a31b..b5c695a 100644
--- a/meson.build
+++ b/meson.build
@@ -80,11 +80,6 @@ if host_machine.system() == 'linux'
   endforeach
 endif

-# Maintain compatibility with autotools on macOS
-if host_machine.system() == 'darwin'
-  common_ldflags += [ '-compatibility_version=1', '-current_version=1.0', ]
-endif
-
 # Functions
 checked_funcs = [
   'bind_textdomain_codeset',

