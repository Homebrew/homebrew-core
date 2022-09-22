class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/43/file-roller-43.0.tar.xz"
  sha256 "298729fdbdb9da8132c0bbc60907517d65685b05618ae05167335e6484f573a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "4beb47f33e5f0829a1bb2afc229327c18e9ea1e555283066df56bae6e8dc35f8"
    sha256 arm64_big_sur:  "49adb5120e4a854e49a3a437a20cecb4968438cf70f9b633733ff4e3dd8cf8dc"
    sha256 monterey:       "a3482cea0278ad464148e4bdb47892b1548a35f25c86aa370c19f64e0d8f95aa"
    sha256 big_sur:        "7c535b2b24a9bd6902dc40ee6423a838c2d5a8e1f65846fa90bb2132c3e67b7f"
    sha256 catalina:       "4aec12ffc7731540e37f874eea27e18ae25b4358f99a0c4bd4c4b48ac19596e9"
    sha256 x86_64_linux:   "b083f2d968ccc6ea981e53fc5105b39ded995f37c49a5115e34e830f91a02981"
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
