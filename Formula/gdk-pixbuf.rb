# gdk-pixbuf: Build a bottle for Linuxbrew
class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "http://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.1.tar.xz"
  sha256 "9d5ba72070460c1b5b74115d395a3e33daeb7b7b67fb256cdccc9d7187c42a38"

  bottle do
    sha256 "9f1032b81b6b372d0a102248ecde6a4bc4cc724926986177087bac591057e360" => :sierra
    sha256 "c08ed90b567abfcb69add70ad7273980d611e6155ebf0bd99eedb3ac2951fc5c" => :el_capitan
    sha256 "7979618692c17d5470b2c4730679054a07575a4fe93d3261a1d29f2bafcab94a" => :yosemite
  end

  option :universal
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
    ENV.universal_binary if build.universal?
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
