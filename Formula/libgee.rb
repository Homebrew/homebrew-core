class Libgee < Formula
  desc "Collection library providing GObject-based interfaces"
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.6.tar.xz"
  sha256 "1bf834f5e10d60cc6124d74ed3c1dd38da646787fbf7872220b8b4068e476d4d"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17b6833c15dcc5a55942ab6efcb13aec78855da1f7caadeb813bdbaf86936990"
    sha256 cellar: :any,                 arm64_monterey: "f4d10b610efe36fcda4140bf67fd793928ab78ee1e1504d3ea41b568ad7de726"
    sha256 cellar: :any,                 arm64_big_sur:  "e68e6466bdb5bd784e482f38187977b844eebde81dc73bff222172d7a2f4a80a"
    sha256 cellar: :any,                 ventura:        "776df5810ebd490091f65aefe8b4f2157fd70670aeb09b940466cfddf09b292d"
    sha256 cellar: :any,                 monterey:       "a7b8c8955ee24c3ec80eeb037ea5f8dafde3fd8070c3db61a45c271530b78e5d"
    sha256 cellar: :any,                 big_sur:        "b9c9f8e2f261e7694ce63061bbf46264392493615cc470b243720a4ae2c7d6ae"
    sha256 cellar: :any,                 catalina:       "859c21092eaf6cb269f2f5f65e7f5a441eb3a73a21abc0bc00a8a103e3413e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6268b9a5755df29c908c02893e7c784e6f37a4f340ae4bc4b17cf05ef8114b6e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    # ensures that the gobject-introspection files remain within the keg
    inreplace "gee/Makefile.in" do |s|
      s.gsub! "@HAVE_INTROSPECTION_TRUE@girdir = @INTROSPECTION_GIRDIR@",
              "@HAVE_INTROSPECTION_TRUE@girdir = $(datadir)/gir-1.0"
      s.gsub! "@HAVE_INTROSPECTION_TRUE@typelibdir = @INTROSPECTION_TYPELIBDIR@",
              "@HAVE_INTROSPECTION_TRUE@typelibdir = $(libdir)/girepository-1.0"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gee.h>

      int main(int argc, char *argv[]) {
        GType type = gee_traversable_stream_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gee-0.8
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgee-0.8
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
