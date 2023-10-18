class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.10.tar.xz"
  sha256 "ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "2fa4dee638dff110b3884b6c878898061a2fed8fe111f3311b9c0c99c37a8cfe"
    sha256 arm64_ventura:  "fe74fd0d46b3042bf5bdc0a281f4d2f4fc873456ca2be043eeb7f9430723f26c"
    sha256 arm64_monterey: "5c995956e552bb56edf6a65394a7638b9c6851e778db47e7038afc671ea05412"
    sha256 arm64_big_sur:  "f875e17f1233c385be75b0d7e1b3a7887c4de1613186cc902de41fa7d4857ad6"
    sha256 sonoma:         "c176aae3c3688e9086a6609e08baa86255d40760e376a1dae14eff8b0f663039"
    sha256 ventura:        "df616ba6672581575db43297f7af9cf7b9220b0dec24d1dc108f2e1ca2c1a1c8"
    sha256 monterey:       "e1fb42aac96f8e1b10dbdf8cbb74957678bfc405885653391f2436facd07e026"
    sha256 big_sur:        "40c99bdc4ae06e902bcefcdd20525f9a3aaef0509d61a18489ab1639572b708a"
    sha256 x86_64_linux:   "a10537012075ba29b2eef89b0f5958bff034f82695fb4ea334c5c50fc9c54e1c"
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
