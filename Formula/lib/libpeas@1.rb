class LibpeasAT1 < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.36/libpeas-1.36.0.tar.xz"
  sha256 "297cb9c2cccd8e8617623d1a3e8415b4530b8e5a893e3527bbfd1edd13237b4c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia:  "ee7c799aac58e588628dc92bef9cdcf28a261b6b3151b33d94914120d2dd0510"
    sha256 arm64_sonoma:   "d8ad718a3d4649bdf4c8c3981dd763682adf2904c1d089a747629447d937028b"
    sha256 arm64_ventura:  "c03ce13e7f2f1251e069aeb9192a519c4d9c1e7a90e1e328b450d0f19d0b96e4"
    sha256 arm64_monterey: "c8e6f7153853cb6bd93e328eda9eda5f86512f13ffb904e46b3c9c8473eb87d0"
    sha256 sonoma:         "05933fc5c5f848da3a886f7b9d9570b80a1dc3f6c0790652fa89dee09e7ea698"
    sha256 ventura:        "912fb7516d914d5f642acd85e634008e2c7684fdd11dd74825779092dfc2fe75"
    sha256 monterey:       "6d15b2225ac18bf8177404a939d0327f6ee262a8bba7dbb8094b80d77eddb397"
    sha256 x86_64_linux:   "b44e4a9f261b68e1ae0f92a08a962d53b7b56f7c90acdc664b062a87cc2d541c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.12"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version "python3.12"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    args = %w[
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
      -Dwidgetry=true
      -Ddemos=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
      -lpeas-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
