class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.3/gom-0.3.3.tar.xz"
  sha256 "ac57e34b5fe273ed306efaeabb346712c264e341502913044a782cdf8c1036d8"
  revision 6

  bottle do
    sha256 "9ac0fa6a00e863a79a22304e11ce8acdc506cc7115efde0f139400548e4084ba" => :catalina
    sha256 "e350f42cc200b16352b511d93e31bd77fe1bafae91bae450e950f9546e109b0b" => :mojave
    sha256 "218193c3f957ef4c999a446bfa6049e978b69f40a40461afaef965b70aaa190a" => :high_sierra
    sha256 "17e82d8af22b8db897ccded270b254c84d67cf7d4be699b2cdc0408982febe60" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  patch :DATA

  def install
    ENV.refurbish_args

    pyver = Language::Python.major_minor_version "python3"

    # prevent sandbox violation
    inreplace "bindings/python/meson.build",
              "install_dir: pygobject_override_dir",
              "install_dir: '#{lib}/python#{pyver}/site-packages'"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gom-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lgom-1.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/bindings/python/meson.build b/bindings/python/meson.build
index feb4a9c..2fda8c1 100644
--- a/bindings/python/meson.build
+++ b/bindings/python/meson.build
@@ -1,33 +1 @@
-python3 = import('python3').find_python()
-
-get_overridedir = '''
-import os
-import sysconfig
-
-libdir = sysconfig.get_config_var('LIBDIR')
-
-if not libdir:
-  libdir = '/usr/lib'
-
-try:
-  import gi
-  overridedir = gi._overridesdir
-except ImportError:
-  purelibdir = sysconfig.get_path('purelib')
-  overridedir = os.path.join(purelibdir, 'gi', 'overrides')
-
-if overridedir.startswith(libdir): # Should always be True..
-  overridedir = overridedir[len(libdir) + 1:]
-
-print(overridedir)
-'''
-
-ret = run_command([python3, '-c', get_overridedir])
-
-if ret.returncode() != 0
-  error('Failed to determine pygobject overridedir')
-else
-  pygobject_override_dir = join_paths(get_option('libdir'), ret.stdout().strip())
-endif
-
 install_data('gi/overrides/Gom.py', install_dir: pygobject_override_dir)

