class Libgee < Formula
  desc "Collection library providing GObject-based interfaces"
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.4.tar.xz"
  sha256 "524c1bf390f9cdda4fbd9a47b269980dc64ab5280f0801b53bc69d782c72de0e"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1cf5cbaa60b52012e61477e1dbcb69b77e9cc16846dc456c855bcbc1d2252563"
    sha256 cellar: :any,                 big_sur:       "0e8f110c3e14f4c45142ad2b215a803b70353e13429a73650e0641cfcda986d5"
    sha256 cellar: :any,                 catalina:      "ce00019f9ca5b8dc93081d84d99b4587a66a3d87b726080ead7323bbec65f417"
    sha256 cellar: :any,                 mojave:        "2d77bae2c373c426ae17050025de1ff6183e84673ebfa144c433a45cdbff8781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e064df49b26118cd962fb582add7ead458cec62f5bcdeefcd2f6a0a6c661e46"
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
