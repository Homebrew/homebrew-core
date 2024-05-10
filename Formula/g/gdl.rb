class Gdl < Formula
  desc "GNOME Docking Library provides docking features for GTK+ 3"
  homepage "https://gitlab.gnome.org/GNOME/gdl"
  url "https://download.gnome.org/sources/gdl/3.40/gdl-3.40.0.tar.xz"
  sha256 "3641d4fd669d1e1818aeff3cf9ffb7887fc5c367850b78c28c775eba4ab6a555"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "1cfd6543098b8fbd77e7fd87c1c16f37d6f486c50323e39bf2d52605409b0f11"
    sha256                               arm64_ventura:  "d896433e025e9c24f986d70fbd82afca5692a82a1a94613b6f4542f341a9896d"
    sha256                               arm64_monterey: "b3769eef48ccbaf262852d48819309afac933d962c7464d4fa3e28a1449b0334"
    sha256                               sonoma:         "4696c6de941ce9c03db4631ce5bc3a53d83f5edfdbff117b3d9c4cba1af3ca1f"
    sha256                               ventura:        "9485abd2cefbb7793c73f8de136bed12524f5e54452bc89b386bc19274f09b1b"
    sha256                               monterey:       "96f6f072cd160b556e5f3e02eb8ffd5cbbe1d4a77877d8f1f4b0d9d986bdfc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b01e8322122e6bbca3d696cb820b83409a1320a3439ef5aa3f56a2de3e908f"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libxml2"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  # Fix build with libxml2 2.12. Remove if upstream PR is merged and in release.
  # PR ref: https://gitlab.gnome.org/GNOME/gdl/-/merge_requests/4
  patch do
    url "https://gitlab.gnome.org/GNOME/gdl/-/commit/414f83eb4ad9e5576ee3d089594bf1301ff24091.diff"
    sha256 "715c804e6d03304bc077b99f667bbeb062c873b3bbd737182fb2cd47a295de95"
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdl/gdl.h>

      int main(int argc, char *argv[]) {
        GType type = gdl_dock_object_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgdl-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgdl-3
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
