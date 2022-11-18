class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.34/libpeas-1.34.0.tar.xz"
  sha256 "4305f715dab4b5ad3e8007daec316625e7065a94e63e25ef55eb1efb964a7bf0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "e0c2f4f3d793b2cb31c147335b8b8a73a936b3a1c92716360906719e36d847ba"
    sha256 arm64_monterey: "f31169f0a56251d8250a7aa3607e4d1dd48c713573af071f94ab53e5023571cf"
    sha256 arm64_big_sur:  "ef7e7384713bc1ff69fe899f7ccc93c9650127a093d1e624b5c23db171ed7e1b"
    sha256 ventura:        "e5519ec916ba85ceffbfe7a6f237eb8569e399d72ec933bc20e728c7387cf8de"
    sha256 monterey:       "e392e3b05c1f5e86bed510ccf197282ad97a6d5ff4e2fb4cfa33b8656806ffb4"
    sha256 big_sur:        "9ee9248b680889d1586a0593d5429d61c3d74bdf007135c0a0813133482ea2c3"
    sha256 catalina:       "ec22a78bc5ec276e481be7c48418e6b47a9540cd3a3ee86e2b8bc33ad145df1a"
    sha256 x86_64_linux:   "cbeeed81c14de0eca458731003ad9558f3b5bb1d159d40b217d3b7c5d1aa3f23"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.10"

  def install
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
