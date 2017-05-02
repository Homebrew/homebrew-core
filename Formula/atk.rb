class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.24/atk-2.24.0.tar.xz"
  sha256 "bb2daa9a808c73a7a79d2983f333e0ba74be42fc51e3ba1faf2551a636487a49"

  bottle do
    sha256 "89d59856b8bbd0a51961c0569237da2f6119fddd40f67b50d96651483fe9be10" => :sierra
    sha256 "87028a5febfcdce413c64f7786468db61b1c62412799405e6b3ac179c0a8ae05" => :el_capitan
    sha256 "e628db1461560fbe5fa9da800987ed2eab6e6c969709797de07a6052521a022e" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
