class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.12.tar.xz"
  sha256 "fff85cf48223ab60e3c3c8318e2087131b590fd6f1737e42cb3759a3b427a334"

  bottle do
    sha256 "17ddba8d07c3afca15aa54cd28aebaf0dc61d14f3707d274f9af919392a764f5" => :mojave
    sha256 "ffac03d4a01258c3d552a1edbd94da33197d252d4439d97cba6c4321654c0d4b" => :high_sierra
    sha256 "c2504014e5e54d6052c50f741869ce09ef5480c718f155e65f62cca41f162c32" => :sierra
    sha256 "bba846fded156d40a4921ce17e69579735875e9b4cd58953abb5206d04b8e120" => :el_capitan
  end

  option "without-modules", "Disable dynamic module loading"
  option "with-included-loaders=", "Build the specified loaders into gdk-pixbuf"

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "jasper" => :optional

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
    # fix libtool versions
    # https://bugzilla.gnome.org/show_bug.cgi?id=776892
    inreplace "configure", /LT_VERSION_INFO=.+$/, "LT_VERSION_INFO=\"3602:0:3602\""
    ENV.append_to_cflags "-DGDK_PIXBUF_LIBDIR=\\\"#{HOMEBREW_PREFIX}/lib\\\""
    args = %W[
      --disable-dependency-tracking
      --disable-maintainer-mode
      --enable-debug=no
      --prefix=#{prefix}
      --disable-Bsymbolic
      --enable-static
      --without-gdiplus
      --enable-introspection=yes
    ]

    args << "--with-libjasper" if build.with?("jasper")
    args << "--disable-modules" if build.without?("modules")

    included_loaders = ARGV.value("with-included-loaders")
    args << "--with-included-loaders=#{included_loaders}" if included_loaders

    system "./configure", *args
    system "make"
    system "make", "install"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/"pkgconfig/gdk-pixbuf-#{gdk_so_ver}.pc" do |s|
      libv = s.get_make_var "gdk_pixbuf_binary_version"
      s.change_make_var! "gdk_pixbuf_binarydir",
        HOMEBREW_PREFIX/"lib/gdk-pixbuf-#{gdk_so_ver}"/libv
    end

    # Remove the cache. We will regenerate it in post_install
    (lib/"gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}/loaders.cache").unlink
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
