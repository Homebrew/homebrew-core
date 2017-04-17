class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.6/graphene-1.6.0.tar.xz"
  sha256 "c3a9910f8dd298c1459d1f3c699ddf2e7440f9e561bfcbef59ae784400e27b5d"

  bottle do
    sha256 "26643b04ec0aa93a3fbc0560f0cc99a24a1894ed94a2d1b48a8a70612ef5f891" => :sierra
    sha256 "ef1e66271b468a48bc6fc18de2bdbdc40c87bdbc51d319f8af0509b107af537c" => :el_capitan
    sha256 "437949adfe70b32ae7145f853b3b133b21aa3df25f5cd5fc52c8f13ef931d094" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "python3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <graphene-gobject.h>

      int main(int argc, char *argv[]) {
      GType type = graphene_point_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/graphene-1.0
      -I#{lib}/graphene-1.0/include
      -L#{lib}
      -lgraphene-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
