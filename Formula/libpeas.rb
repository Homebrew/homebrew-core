class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.24/libpeas-1.24.0.tar.xz"
  sha256 "0b9a00138c129a663de3eef5569b00ace03ce31d345f7af783768e9f35c8e6f9"

  bottle do
    sha256 "7246dd3f3c2c93911607c1014f8197c412a8af1cf8d5da09ae7c9b48fffea170" => :mojave
    sha256 "cf2080f0de201ba6ccffac5a5e3a7e190c834404042a36050751fe572da0f9ff" => :high_sierra
    sha256 "ca5cf053b9b12849838edfb89451da7ca468c215f66ae7233ed5e99199c0860e" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python"

  # patch submitted upstream as https://gitlab.gnome.org/GNOME/libpeas/merge_requests/15
  patch do
    url "https://gitlab.gnome.org/GNOME/libpeas/commit/8500981.diff"
    sha256 "61650bdca802631a67556edf8306e53e4b6d632fcb614ca9e3b397b02ef36092"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/libpeas/commit/bd80538.diff"
    sha256 "4c0a7cd4f9147450e4d163493d6ed050056dd4c2dbc666ef30e9fe60d936f0bd"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
      -Dwidgetry=true
      -Ddemos=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -lpeas-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
