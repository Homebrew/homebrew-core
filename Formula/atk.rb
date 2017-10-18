class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.26/atk-2.26.0.tar.xz"
  sha256 "eafe49d5c4546cb723ec98053290d7e0b8d85b3fdb123938213acb7bb4178827"

  bottle do
    sha256 "5c78c2bdd6e8da5bd8460bed64f55267acfc5eb02f79b40858a3114b5aa7181d" => :high_sierra
    sha256 "75d877312be453f0bd061c95ec1d1bd46723aac2e3faa6639ae82410a2191c7d" => :sierra
    sha256 "985f4a5bea1cf987504fe997cc2bcd51d1ec71ddac2b8744c074d6b3a706466f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make", "install"
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
