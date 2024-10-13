class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.12.tar.xz"
  sha256 "b9505b3445b9a7e48ced34760c3bcb73e966df3ac94c95a148cb669ab748e3c7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "ed8778a0516a3998bc1522378a4391750c6e105611ae6ac9a062950ce6a43dc1"
    sha256 arm64_sonoma:   "25939bb8cc913348f52c3c72ad16089b15cd2293397b3a9a4bcec90dbd409987"
    sha256 arm64_ventura:  "b5d7e955fda95853264840a0f05fa7c9f1d7b45a08e0d1b4bcf15c16b3c03820"
    sha256 arm64_monterey: "a32e123ccc804f092841336600e33fc67c6ac912d5aee8f99465afd7390014db"
    sha256 sonoma:         "3e7266d92df1d8a3afde5e67030878a610ede9d9dfa75572e54dcb74d5779cdc"
    sha256 ventura:        "80e5eacf286d8371d7fcc13cc9b79d4612ded6d0db3398c5741790174ae70f85"
    sha256 monterey:       "8949303fe5fe4f755cdde41339de6485b4fc0da74b9991eafb78eabe6fe38e1e"
    sha256 x86_64_linux:   "1acee0ae28b67cd12f744e7923ff8a5e8c9396777af0bb661089b6e33492b8b3"
  end

  depends_on "docutils" => :build # for rst2man
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "shared-mime-info"
  end

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

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Drelocatable=false",
                                      "-Dnative_windows_loaders=false",
                                      "-Dtests=false",
                                      "-Dinstalled_tests=false",
                                      "-Dman=true",
                                      "-Dgtk_doc=false",
                                      "-Dpng=enabled",
                                      "-Dtiff=enabled",
                                      "-Djpeg=enabled",
                                      "-Dothers=enabled",
                                      "-Dintrospection=enabled",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/"pkgconfig/gdk-pixbuf-#{gdk_so_ver}.pc" do |s|
      libv = s.get_make_var "gdk_pixbuf_binary_version"
      s.change_make_var! "gdk_pixbuf_binarydir",
        HOMEBREW_PREFIX/"lib/gdk-pixbuf-#{gdk_so_ver}"/libv
    end
  end

  # The directory that loaders.cache gets linked into, also has the "loaders"
  # directory that is scanned by gdk-pixbuf-query-loaders in the first place
  def module_dir
    "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-#{gdk_so_ver}/#{gdk_module_ver}"
  end

  def post_install
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{module_dir}/loaders"
    system bin/"gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdk-pixbuf/gdk-pixbuf.h>

      int main(int argc, char *argv[]) {
        GType type = gdk_pixbuf_get_type();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gdk-pixbuf-#{gdk_so_ver}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
