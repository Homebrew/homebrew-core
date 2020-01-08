class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.24/libpeas-1.24.1.tar.xz"
  sha256 "9c3acf7a567cbb4f8bf62b096e013f12c3911cc850c3fa9900cbd5aa4f6ec284"

  bottle do
    sha256 "0b0f838272f0a44cb81c70fffb984a054a12ea63f6b515aab1f1158bc96bad1b" => :catalina
    sha256 "504886a5e23802e49f8a10de0bc0547f4235854ae3eae3ac87fa3aed39ab50c1" => :mojave
    sha256 "be6e36451525d6b365159b177eea7a1b92fc2cae3376a923970eef2f432cba16" => :high_sierra
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

  # patch submitted upstream as https://gitlab.gnome.org/GNOME/libpeas/merge_requests/22
  patch do
    url "https://gitlab.gnome.org/GNOME/libpeas/commit/d5f5749372.diff"
    sha256 "a46c4229656423de2e277bf5dd96e7f595cee19cc112c10f422c29c960cf4dcc"
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
