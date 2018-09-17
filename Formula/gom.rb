class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.3/gom-0.3.3.tar.xz"
  sha256 "ac57e34b5fe273ed306efaeabb346712c264e341502913044a782cdf8c1036d8"
  revision 5

  bottle do
    sha256 "20f9cc7aff0bce649e242e58c9b02938101c5fee37a4dde0941c76b7beded683" => :mojave
    sha256 "90cc6ffc759414df0b846d26adf400ffc512c408854923e9aa34da0506351883" => :high_sierra
    sha256 "e74c3a447e1732a170689526644c6d1f208ce4d48ba3c7f82de491f6c4620ca5" => :sierra
    sha256 "7b08fdd3e5744b3bfa8e72333dde59a9a258692e680d67e191d09b0460008dc0" => :el_capitan
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

