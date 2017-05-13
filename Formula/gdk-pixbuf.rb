class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.6.tar.xz"
  sha256 "455eb90c09ed1b71f95f3ebfe1c904c206727e0eeb34fc94e5aaf944663a820c"

  bottle do
    rebuild 1
    sha256 "3773ef77ffe5fed4c613fcaa071b0ba0b956d6a65b0018d5589220fd56a42bbc" => :sierra
    sha256 "e9404c615bb81cdb866471955a4c6c504ea480af58828d606d100041ca7a399c" => :el_capitan
    sha256 "208d7c9e7bbf789954fb117bbb76028760cb7bef0739ddbd91f3a18b7fab094c" => :yosemite
  end

  option "with-relocations", "Build with relocation support for bundles"
  option "without-modules", "Disable dynamic module loading"
  option "with-included-loaders=", "Build the specified loaders into gdk-pixbuf"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "gobject-introspection"
  depends_on "shared-mime-info"

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
      --enable-introspection=yes
      --disable-Bsymbolic
      --enable-static
      --without-gdiplus
    ]

    args << "--enable-relocations" if build.with?("relocations")
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

  def caveats
    if build.with?("relocations") || HOMEBREW_PREFIX.to_s != "/usr/local"
      <<-EOS.undent
        Programs that require this module need to set the environment variable
          export GDK_PIXBUF_MODULEDIR="#{module_dir}/loaders"
        If you need to manually update the query loader cache, set these variables then run
          #{bin}/gdk-pixbuf-query-loaders --update-cache
      EOS
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
