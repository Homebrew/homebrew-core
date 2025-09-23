class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.61/librsvg-2.61.1.tar.xz"
  sha256 "bc1bbcd419120b098db28bea55335d9de2470d4e6a9f6ee97207b410fc15867d"
  license "LGPL-2.1-or-later"

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0068d78a89b6798408d4c8c33526ed875b878eac958a3f9c60fdad23394d3bcc"
    sha256 cellar: :any, arm64_sequoia: "2a8c5077f2ce8a4abdbe08e72cdfa0b8b28c2be4ccc436220affd7cbfcd79de5"
    sha256 cellar: :any, arm64_sonoma:  "c5f91a72fcd3aec0e4b7cdb4d4c1c3210501ae4fc0068bd6d6f96bec509f74c7"
    sha256 cellar: :any, arm64_ventura: "3022d5381efac2b3741f5701948dd654089f48e4fddb7ed645e2a566a59c3771"
    sha256 cellar: :any, sonoma:        "60cb3cfba6424c682559c934156d776ce253a6d18380f8950d3a56a0502a3ac6"
    sha256 cellar: :any, ventura:       "e711f8084e504a3718e7da9110300028f54bc5e0e086a61418c8f1aebe8dcf93"
    sha256               arm64_linux:   "a10626bd24edf3ed3e0e8284b23252ce6e1c451ba7025d4fe89848da3c1bf4bf"
    sha256               x86_64_linux:  "4d83f2b04946793756fcd8e610652c2f8d899ba59531626511a28ebb5133f32b"
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
