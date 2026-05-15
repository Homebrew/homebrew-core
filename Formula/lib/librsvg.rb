class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.62/librsvg-2.62.2.tar.xz"
  sha256 "c0c1367e381e1ae4842a78f1b57c656ff19b25637e3a6527cb44ae5a1cc68d65"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de383d6b53e97dd11cf3e9ee02e41a9da53524455577beba41462d9c06acc357"
    sha256 cellar: :any, arm64_sequoia: "76b188dc1b43d97a4ea99d931fb8d5fa654accf749d897b27dec90ee0265a542"
    sha256 cellar: :any, arm64_sonoma:  "42853ce8bb3ef1b0742f6388b0e721df8b6d6cf69e27f92f4df3a85aaa5b9dc4"
    sha256 cellar: :any, sonoma:        "8e552f84730b2ec1c8447f3f46bf233d83469a05528323d2c078a7f0f3630429"
    sha256               arm64_linux:   "ae80e520cadf0cb571b5ff09b82a36ef26cf845417c477a19ac40d294d60a640"
    sha256               x86_64_linux:  "a89cc65e90cff8ab1c1f0d2e2809a54ad6bf15761d619743afc7c4868d8fd279"
  end

  depends_on "cargo-c" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "libpng"
  end

  def install
    # Set `RPATH` since `cargo-c` doesn't seem to.
    rpath_flags = [rpath, rpath(source: lib/"gdk-pixbuf-2.0/2.10.0/loaders")].map { |rp| "-rpath,#{rp}" }
    ENV.append_to_rustflags "--codegen link-args=-Wl,#{rpath_flags.join(",")}" if OS.mac?

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
