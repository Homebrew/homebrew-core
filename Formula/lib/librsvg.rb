class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.59/librsvg-2.59.2.tar.xz"
  sha256 "ecd293fb0cc338c170171bbc7bcfbea6725d041c95f31385dc935409933e4597"
  license "LGPL-2.1-or-later"

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "62c2bd6cd94b22a8231b423b1a1fc9084c8496e2ffd08fda39df2a11af3b668f"
    sha256                               arm64_sonoma:   "12c692788acb39a1b01ab52ec3a9042a590449dc4c1ca3a37f6dfb8de1ade404"
    sha256                               arm64_ventura:  "42eeef26afba840075b5a42b644a2ee369c280dbd955eff559edad4c5e310edd"
    sha256                               arm64_monterey: "fcb9205a1cf574f392c5188e85f90f3a96d36d9bd65cbde98b3481ad02c23887"
    sha256                               sonoma:         "593325eefc9b94aeb1c1b3186add9d4b980e195c617a7e736ee9498b177fae85"
    sha256                               ventura:        "67f803506a82f16b08461005382dbabfce218ec9dca90f2159fa467e6e5cdaeb"
    sha256                               monterey:       "eb49065b7846d1f7fa4a1cab3baa0048f689288eb8512e09ea7a5d64fbe47290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c71dffd85fd7b3553766305adf685a59fc00b87d3120f0e96b199f079ac0fda"
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
