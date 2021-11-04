class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz"
  sha256 "c4a6b75b7ed8f58ca48da830b9fa00ed96d668d3ab4b1f723dcf902f78bde77f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "328f6bdde8798f079a1b4abbd60f9ca9f6f1c308efb44eec863421817af4d7a8"
    sha256 arm64_big_sur:  "1aa92bcea0846fe0b37a4d65bf5947f5c27ffc750a93bd94db69bfe25369fda3"
    sha256 monterey:       "d8984c02730154183bde0adfcde24fa47bc7611eb134a77e20d15b17b3be4de9"
    sha256 big_sur:        "f4cf795b20c84fb5074ceeeeaf7b1d22e164b7af13adb6d0b95e3655d867fd41"
    sha256 catalina:       "94835aba06d5e7160fd19bb14e05d3aad2f27be4c7030c019e42208369cf6014"
    sha256 mojave:         "4bd3543b83cd74bfd0de1bd94a9e0200374c0834ef636cfe99621fe3c2145aaa"
    sha256 x86_64_linux:   "cd3d671f4129a4dddef888e1317b4e5840d217b75fee8e46a17b33630da674c8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
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

    args = std_meson_args + %w[
      -Drelocatable=false
      -Dnative_windows_loaders=false
      -Dinstalled_tests=false
      -Dman=false
      -Dgtk_doc=false
      -Dpng=true
      -Dtiff=true
      -Djpeg=true
      -Dintrospection=enabled
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
