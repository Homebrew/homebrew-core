class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.44/gdk-pixbuf-2.44.7.tar.xz"
  sha256 "172f80e3626ec31520a970400f1a3694e04718f6c2cd2885f75250fb5a6995a4"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256               arm64_tahoe:   "cd4fd8a86348bfee4bf256f152b531c0d288240f9656a07bf0ab7d10f06140e8"
    sha256               arm64_sequoia: "6489f7aca7522b517352cac6e2e6af6fa95caa3deff8c056d7f12d8fd690918a"
    sha256               arm64_sonoma:  "884f7f07fd86403c09fd476cdb4ae4718dfe0c2824b929fcb2ac50281262cfe1"
    sha256 cellar: :any, sonoma:        "f9e21c474ddef289d75847583f4237f4077815322b0d3c7a84fef1cd67358e36"
    sha256               arm64_linux:   "69e8fad8603fd575e7e12deaac3e77038aa96a8a8b8bae3a297f3a3cc467bc91"
    sha256               x86_64_linux:  "8b0ad8c3516f436a81c69e7c4e1157a44bf4f6d8e8037b12a80c61553868a3d1"
  end

  depends_on "docutils" => :build # for rst2man
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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

  def install
    # Use HOMEBREW_PREFIX to find modules installed by dependents without
    # needing environment variables or inreplaces. In order to support this,
    # we need install into a staging directory.
    ENV["DESTDIR"] = buildpath/"stage"

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
                                      "-Dglycin=disabled",
                                      *std_meson_args(prefix: HOMEBREW_PREFIX)
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    prefix.install Pathname(File.join("stage", HOMEBREW_PREFIX)).children
  end

  post_install_steps do
    gdk_pixbuf_query_loaders
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gdk-pixbuf/gdk-pixbuf.h>

      int main(int argc, char *argv[]) {
        GType type = gdk_pixbuf_get_type();
        return 0;
      }
    C

    gdk_pixbuf_pc = lib.glob("pkgconfig/gdk-pixbuf-*.pc").first.basename(".pc")
    flags = shell_output("pkgconf --cflags --libs #{gdk_pixbuf_pc}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # Check that HOMEBREW_PREFIX paths are used
    gdk_pixbuf_cache_file = shell_output("pkgconf --variable=gdk_pixbuf_cache_file #{gdk_pixbuf_pc}").chomp
    loaders = shell_output(bin/"gdk-pixbuf-query-loaders")
    assert_match "#{HOMEBREW_PREFIX}/lib/", gdk_pixbuf_cache_file
    assert_match "LoaderDir = #{HOMEBREW_PREFIX}/lib/gdk-pixbuf-", loaders
    refute_match prefix.realpath.to_s, loaders
  end
end
