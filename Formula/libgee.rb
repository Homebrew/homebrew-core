class Libgee < Formula
  desc "Collection library providing GObject-based interfaces"
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.5.tar.xz"
  sha256 "31863a8957d5a727f9067495cabf0a0889fa5d3d44626e54094331188d5c1518"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b4c0eb232ec495a1133db8cd3f639658033a25ce178ec00b858e8a33957d4221"
    sha256 cellar: :any,                 arm64_big_sur:  "7595f10a228290c80b8059dff874470cfb76840b443096a3b97bfe6e27390a6b"
    sha256 cellar: :any,                 monterey:       "8136138b5bbaeec36919d40184697874f473a5bf5e0a552cbec4d86e85273072"
    sha256 cellar: :any,                 big_sur:        "1be6807d7a7b14d96503e8bf534c0535b83defe13eb467c478d729eb5ddd9d9c"
    sha256 cellar: :any,                 catalina:       "7e72f9c9158e3ff6364672a300728bdfb4394a5d73dd39a2ae53da96ce456ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6746f72a5fc51d595da9fe6854598c74228caeabbc0a5a061bd78bf44c72d424"
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
