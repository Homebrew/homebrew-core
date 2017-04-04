class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.6.tar.xz"
  sha256 "455eb90c09ed1b71f95f3ebfe1c904c206727e0eeb34fc94e5aaf944663a820c"

  bottle do
    sha256 "6026f7a751626fe99d5b6e7a061b617869478e728cb3391f01605ebfa97767da" => :sierra
    sha256 "4c6dea60fdfc92710e4c20e2ce1ba8cc2a9c7e50e9e67af176a24a820eeb965e" => :el_capitan
    sha256 "99127ea6b17e595d145ad2fa4bbdd41aaed46982c2302a18adaf3479a4df6b8d" => :yosemite
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

  # 'loaders.cache' must be writable by other packages
  skip_clean "lib/gdk-pixbuf-2.0"

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

  # Where we want to store the loaders.cache file, which should be in a
  # Keg-specific lib directory, not in the global Homebrew lib directory
  def module_file
    "#{lib}/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}/loaders.cache"
  end

  # The directory that loaders.cache gets linked into, also has the "loaders"
  # directory that is scanned by gdk-pixbuf-query-loaders in the first place
  def module_dir
    "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}"
  end

  def post_install
    ENV["GDK_PIXBUF_MODULE_FILE"] = module_file
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{module_dir}/loaders"
    system "#{bin}/gdk-pixbuf-query-loaders", "--update-cache"
    # Link newly created module_file into global gdk-pixbuf directory
    ln_sf module_file, module_dir
  end

  def caveats
    if build.with?("relocations") || HOMEBREW_PREFIX.to_s != "/usr/local"
      <<-EOS.undent
        Programs that require this module need to set the environment variable
          export GDK_PIXBUF_MODULE_FILE="#{module_file}"
          export GDK_PIXBUF_MODULEDIR="#{module_dir}/loaders"
        If you need to manually update the query loader cache, set these variables then run
          #{bin}/gdk-pixbuf-query-loaders --update-cache
      EOS
    end
  end

  test do
    system bin/"gdk-pixbuf-csource", test_fixtures("test.png")
  end
end
