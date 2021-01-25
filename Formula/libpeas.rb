class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.28/libpeas-1.28.0.tar.xz"
  sha256 "42d91993b46ed50f16add6d9577ecc22beb8e2dffa7101e2232c2b63733b8b15"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "e16499f8ca12b73b560186938cc435ebb57b9ad5b212f402bfef5fb1817d086f" => :big_sur
    sha256 "665cf2215ffd3be1079233e2f825790dd0a000b3171deafd4547c76f8e900830" => :arm64_big_sur
    sha256 "32809467a203d5da8fe2168c50a773c950ea906ab06a3010fc4287de0b8f407d" => :catalina
    sha256 "a9e812e0fb512c3a6716deca92a1c58fd4a1f4ee5f6af3e0fa255c97dd08d294" => :mojave
    sha256 "bfe333e7b1268b37d498a15087e07a6f09e736ed338dc4f694d40475ab736f40" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    args = std_meson_args + %w[
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
