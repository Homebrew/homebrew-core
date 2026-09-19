class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.63/librsvg-2.63.2.tar.xz"
  sha256 "852b18e1a00b8605528825a27dc7748bff2a5dd254028f59dc22a34ea57e81b6"
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
    sha256 cellar: :any, arm64_golden_gate: "f4de90642a4e8829b46e35e9acaab80c6d61da5a755052609a925796792c9d80"
    sha256 cellar: :any, arm64_tahoe:       "d3bdde8b9fbbf1cea9e2441a706bcdb0b5021d4071ccbbc13b16c998329289b8"
    sha256 cellar: :any, arm64_sequoia:     "204d76fea44e7eaf6d2a1cb6d51ba5021b031af2b9457efdfb8e2f9616b3254a"
    sha256 cellar: :any, arm64_sonoma:      "d6b3b7a944924d2613cb21d6fa4e76418efe7ab86f21e667345b13fdf779d00e"
    sha256 cellar: :any, arm64_linux:       "c072dc0d0264571fc51b6fd449e6b08ec4a8d7b6f8f7550fac2ce8d97614bcff"
    sha256 cellar: :any, x86_64_linux:      "fe46d20f7c8599e05feaaa9d87810f4732fba7f7a946d75ff93431c49b7feeda"
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
