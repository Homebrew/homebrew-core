class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.60/librsvg-2.60.0.tar.xz"
  sha256 "0b6ffccdf6e70afc9876882f5d2ce9ffcf2c713cbaaf1ad90170daa752e1eec3"
  license "LGPL-2.1-or-later"

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0963c3ac5eab8defa0d871e6f14f376ecb580f87a7369e2d8b6ed1ba5a97b009"
    sha256 cellar: :any, arm64_sonoma:  "a98fcd2388cb75ba4afe95feb7955b0400c1cacb067101378a33bfe295ebe2da"
    sha256 cellar: :any, arm64_ventura: "d6603d7add86e0cc825872bf044e7d9dc19693090ee93ef5248825299f7bef01"
    sha256 cellar: :any, sonoma:        "634f5d94e39ccf7eff754510cd12db72ce3cbc797161227a1f7b8e3a910438df"
    sha256 cellar: :any, ventura:       "5c3d74c400bf0cfc86010f98dba262c10c39f66f743509a3127b9246cb4e3111"
    sha256               arm64_linux:   "97199cca04e0499e5084ce8ccf043d3d48a3dde4744b9273d7d9021e393f2b36"
    sha256               x86_64_linux:  "c3fb7a85f3c84f3c3edd0740dd5c8fd2cc7371cebf1088be130423255eb8514f"
  end

  depends_on "cargo-c" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libpng"
  end

  def install
    # Set `RPATH` since `cargo-c` doesn't seem to.
    ENV.append "RUSTFLAGS", "--codegen link-args=-Wl,-rpath,#{lib}" if OS.mac?

    # disable updating gdk-pixbuf cache, we will do this manually in post_install
    # https://github.com/Homebrew/homebrew/issues/40833
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dintrospection=enabled",
                                      "-Dpixbuf=enabled",
                                      "-Dpixbuf-loader=enabled",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Workaround until https://gitlab.gnome.org/GNOME/librsvg/-/merge_requests/1049
    if OS.mac?
      gdk_pixbuf_moduledir = lib.glob("gdk-pixbuf-*/*/loaders").first
      gdk_pixbuf_modules = gdk_pixbuf_moduledir.glob("*.dylib")
      odie "Try removing .so symlink workaround!" if gdk_pixbuf_modules.empty?
      gdk_pixbuf_moduledir.install_symlink gdk_pixbuf_modules.to_h { |m| [m, m.sub_ext(".so").basename] }
    end
  end

  def post_install
    # librsvg is not aware GDK_PIXBUF_MODULEDIR must be set
    # set GDK_PIXBUF_MODULEDIR and update loader cache
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librsvg/rsvg.h>

      int main(int argc, char *argv[]) {
        RsvgHandle *handle = rsvg_handle_new();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs librsvg-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
