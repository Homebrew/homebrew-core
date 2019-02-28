class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.38/gdk-pixbuf-2.38.1.tar.xz"
  sha256 "f19ff836ba991031610dcc53774e8ca436160f7d981867c8c3a37acfe493ab3a"

  bottle do
    sha256 "191484223e3008e91fef28edaac87fddaac10f65e4a061dda3d2e783deb9049e" => :mojave
    sha256 "7213023a24faa8c847d742cb2c8994416abad45c6f9117274b04821e83df866a" => :high_sierra
    sha256 "1ad9524a855f609809fc404b68afc6cb417b856921fec44b0710301a74289562" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # gdk-pixbuf has an internal version number separate from the overall
  # version number that specifies the location of its module and cache
  # files, this will need to be updated if that internal version number
  # is ever changed (as evidenced by the location no longer existing)
  def gdk_so_ver
    "2.0"
  end

  def gdk_module_ver
    "2.10.0"
  end

  def install
    inreplace "gdk-pixbuf/meson.build",
              "-DGDK_PIXBUF_LIBDIR=\"@0@\"'.format(gdk_pixbuf_libdir)",
              "-DGDK_PIXBUF_LIBDIR=\"@0@\"'.format('#{HOMEBREW_PREFIX}/lib')"

    args = %W[
      --prefix=#{prefix}
      -Dx11=false
      -Ddocs=false
      -Dgir=true
      -Drelocatable=false
      -Dnative_windows_loaders=false
      -Dinstalled_tests=false
      -Dman=false
    ]

    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install"
    end

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/"pkgconfig/gdk-pixbuf-#{gdk_so_ver}.pc" do |s|
      libv = s.get_make_var "gdk_pixbuf_binary_version"
      s.change_make_var! "gdk_pixbuf_binarydir",
        HOMEBREW_PREFIX/"lib/gdk-pixbuf-#{gdk_so_ver}"/libv
    end

    # fix gobject-introspection support
    # will not be necessary after next release of gobject-introspection
    %w[GdkPixbuf-2.0 GdkPixdata-2.0].each do |gir|
      inreplace share/"gir-1.0/#{gir}.gir", "@rpath", lib.to_s
      system "g-ir-compiler", "--includedir=#{share}/gir-1.0", "--output=#{lib}/girepository-1.0/#{gir}.typelib", share/"gir-1.0/#{gir}.gir"
    end
  end

  # The directory that loaders.cache gets linked into, also has the "loaders"
  # directory that is scanned by gdk-pixbuf-query-loaders in the first place
  def module_dir
    "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}"
  end

  def post_install
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{module_dir}/loaders"
    system "#{bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdk-pixbuf/gdk-pixbuf.h>

      int main(int argc, char *argv[]) {
        GType type = gdk_pixbuf_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gdk-pixbuf-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgdk_pixbuf-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
