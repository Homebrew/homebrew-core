class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"
  license "LGPL-2.1-or-later"
  revision 3

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_sequoia: "26645233d1bbd2e1205ffc9e20f4e4a1bc5e1b06cf48713f2a49ab9f9528abf4"
    sha256 cellar: :any, arm64_sonoma:  "815ac85e0eacef51123299d5812c4119335552cd9202704fcf4a76767db72be3"
    sha256 cellar: :any, arm64_ventura: "f7e330f1f70e94eb254c6c258e916186cf42306b2db1428d681bed8737bb5a94"
    sha256 cellar: :any, sonoma:        "db7c3819f0a834aa8aa355d81cc3a11e58dd29ea0ffc3608c014b46dc6143fb8"
    sha256 cellar: :any, ventura:       "f04b019a8c7a4e71787cafea302e2f67442932518f3f708178d24ee7cc7ce544"
    sha256               x86_64_linux:  "75865eb8f914d3d3b10059f06790f57273780a109f83949879808aacb9b7fadd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "sqlite" # indirect dependency via glib

  def install
    site_packages = prefix/Language::Python.site_packages("python3.13")

    system "meson", "setup", "build", "-Dpygobject-override-dir=#{site_packages}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    C
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
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
