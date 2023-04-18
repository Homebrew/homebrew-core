class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.10.tar.xz"
  sha256 "ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "e399064e72c6d5a754054ab177507d166d61fcf8a774880ef18f0c5c25d7c8b4"
    sha256 arm64_monterey: "f944e2943561a8a5b1c1c4e634b91a33ab1bda82c65c695b70c4b87fc48f9ca0"
    sha256 arm64_big_sur:  "c0fc7bfadb4517e194091ace0929823af4bb2e663b17e6d19b326e7181ec9c7c"
    sha256 ventura:        "beabd0e8b0b94cb186a5856d807312c57a008259822a06548b7c170c46ed914c"
    sha256 monterey:       "555cb431231ed77067e66782bfb00623fdbd1cb17350800f2e0cf8aa8ae6fb33"
    sha256 big_sur:        "3861e9ecafbbddede7af2fc0c4da7a80c97e4384705551e4527d3247444cdbcf"
    sha256 x86_64_linux:   "f49f3d34c8671c9dff090f7f943fd55223a3a0d0f3fe6411be6f73c34daa6501"
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
    flags = shell_output("pkg-config --cflags --libs gdk-pixbuf-#{gdk_so_ver}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
