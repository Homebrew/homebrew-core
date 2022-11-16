class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.10.tar.xz"
  sha256 "ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "c14d053406b8a348e6cb16d6cd143ee1aba292e966222add9dbb0a31c91054fc"
    sha256 arm64_monterey: "5062e2c1e4fec51a665fe5893f12e8aee82e635469e7a1233f114ebe00da212f"
    sha256 arm64_big_sur:  "5561aaebdd1d83449a3f5101442dffe1b3a20f61ff003c5d266f5f5758b7796d"
    sha256 ventura:        "cdf70ce6d7b7d7c1dfaecd3e490a9086109356d105d9e9c59e9efc5cd04cc2d0"
    sha256 monterey:       "4494ae162cf4a40ff384bcdda6082456c7e5b5eb7b713286c8ea1d8fdf876e75"
    sha256 big_sur:        "8f5fb95bbe6dc3f8738473c1964c1c5614340378ea30b0c8e3c8507888d3bb3a"
    sha256 catalina:       "d1dd8c3e4221b684164efcb7393e91607c3a472dd9c43271dc50856b583c5c93"
    sha256 x86_64_linux:   "3309a7fef974594a786d317e9be0a8e4f1001e362ff2d8186107f3f6c163b7e4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
    system "meson", *std_meson_args, "build",
                    "-Drelocatable=false",
                    "-Dnative_windows_loaders=false",
                    "-Dinstalled_tests=false",
                    "-Dman=false",
                    "-Dgtk_doc=false",
                    "-Dpng=enabled",
                    "-Dtiff=enabled",
                    "-Djpeg=enabled",
                    "-Dintrospection=enabled"
    system "meson", "compile", "-C", "build", "-v"
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
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
