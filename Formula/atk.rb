class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.20/atk-2.20.0.tar.xz"
  sha256 "493a50f6c4a025f588d380a551ec277e070b28a82e63ef8e3c06b3ee7c1238f0"

  bottle do
    sha256 "22ef1732768f4e044c726d472f8df3b65d6ec551a48281b7510f9353bc4a2bf2" => :el_capitan
    sha256 "39faebf76827aa4cdf00c5773d734701dec79dc0ed39b0f4bc5e002ebb73aec4" => :yosemite
    sha256 "ef489d35b9bf74d41110287fbccab60c0581005cfa91f55cacaa642f5a184896" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    ENV.universal_binary if build.universal?
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
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
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
