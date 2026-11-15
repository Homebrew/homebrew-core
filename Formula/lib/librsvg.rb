class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.63/librsvg-2.63.4.tar.xz"
  sha256 "31f07d9350dad3f8964fd613c31309ac160fdef13dfac59df6fd082de78d6e8f"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/librsvg.git", branch: "main"

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4bf727a10083f030348c98b94bd1589092527c42fc119efd9b622f37287b5e33"
    sha256 cellar: :any, arm64_tahoe:       "9e66074a308d2245eb81886bc5648dc22acbb113d80a5076bf45dd5212034239"
    sha256 cellar: :any, arm64_sequoia:     "7cec71ffb43c1515ab1407fbc4ebee727653d71f9e5b152aa752f3e3d7a4f226"
    sha256 cellar: :any, arm64_linux:       "efc74b2e1998f5aec882fbd293a878ba19410159d0572392fa4401e7851db27e"
    sha256 cellar: :any, x86_64_linux:      "f7d77a97b046c52717a3247fd23ec816a44da19b8f03e50453ba4b6d7ebbec6c"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    gdk_pixbuf_moduledir = formula_opt_lib("gdk-pixbuf").glob("gdk-pixbuf-*/*/loaders").fetch(0)
    gdk_pixbuf_moduledir = prefix/gdk_pixbuf_moduledir.relative_path_from(formula_opt_prefix("gdk-pixbuf"))

    # Set `RPATH` since `cargo-c` doesn't seem to.
    rpath_flags = [rpath, rpath(source: gdk_pixbuf_moduledir)].map { |rp| "-rpath,#{rp}" }
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
      gdk_pixbuf_modules = gdk_pixbuf_moduledir.glob("*.dylib")
      odie "Try removing .so symlink workaround!" if gdk_pixbuf_modules.empty?
      gdk_pixbuf_moduledir.install_symlink gdk_pixbuf_modules.to_h { |m| [m, m.sub_ext(".so").basename.to_s] }
    end
  end

  post_install_steps do
    update_gdk_pixbuf_loaders_cache
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
