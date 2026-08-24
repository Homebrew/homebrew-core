class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.44/gdk-pixbuf-2.44.8.tar.xz"
  sha256 "919f529512961a12e81cd4b4b466a48c3933469e7f9a310c6513cd4fb252ba3c"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256               arm64_tahoe:   "f0ac042950d94a60fac215407e17eb883fbc9881c2943d972b947512d7b981aa"
    sha256               arm64_sequoia: "78528797c7e12036f457417018122651f151ad84e40e5a94dab06ab4c928ab90"
    sha256               arm64_sonoma:  "023a3064bdb11d805971bc221046448ede9aacd21f87d9a2b888ce95f83e5838"
    sha256 cellar: :any, sonoma:        "311c6af6afa4d53a01cf0834288928254a6131eb249d6bbc1171574dade7928d"
    sha256               arm64_linux:   "be7d9919b3b9b9df245240ec0451ab0cf5118c31f5b476ae0e2f1cdeaa901ac3"
    sha256               x86_64_linux:  "13498f2cb02bb122c7befb4e3eaa4a79aca7d736f1c5cb68c85088fc70f37f24"
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
    update_gdk_pixbuf_loaders_cache
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
