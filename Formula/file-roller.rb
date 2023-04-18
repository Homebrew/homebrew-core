class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/43/file-roller-43.0.tar.xz"
  sha256 "298729fdbdb9da8132c0bbc60907517d65685b05618ae05167335e6484f573a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "8d9d4d1a6e8951aab53925d81fea894e42673e44e74334de7389e4d4e0c45893"
    sha256 arm64_monterey: "24c57252d20bf9c50965dbcd6758119b857455f98be186352e39f62220850708"
    sha256 arm64_big_sur:  "20562e6dd43c1837bbd477a0772e54969e7b1941443232a638136046c3303a5d"
    sha256 ventura:        "69b06c6384434180a556b6c0e41021b836911e130edd19d8a48480ca441becd7"
    sha256 monterey:       "34b892ba595a685455bfcffd699676e4773fb4fac5a32ee8ed72b78bf9562e7e"
    sha256 big_sur:        "ca90cd09d4b7c310c39851d6880391a04c8838a82d4e00d9c3c275ce834d962d"
    sha256 catalina:       "8e6a700c11ca46f433b159faa2aecc425791aa1b7acf9f6b8dd8a69b3caf1820"
    sha256 x86_64_linux:   "26fafa0ed18cc3e19567609ed448f6cd6bae516a5490d71d16580d1bf4b45e0c"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libhandy"
  depends_on "libmagic"

  def install
    # Patch out gnome.post_install to avoid failing when unused commands are missing.
    # TODO: Remove when build no longer fails, which may be possible in following scenarios:
    # - gnome.post_install avoids failing on missing commands when `DESTDIR` is set
    # - gnome.post_install works with Homebrew's distribution of `gtk+3`
    # - `file-roller` moves to `gtk4`
    inreplace "meson.build", /^gnome\.post_install\([^)]*\)$/, ""

    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"
    ENV["DESTDIR"] = "/"

    system "meson", *std_meson_args, "build", "-Dpackagekit=false", "-Duse_native_appchooser=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end
