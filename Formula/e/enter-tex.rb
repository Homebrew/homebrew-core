class EnterTex < Formula
  desc "TeX/LaTeX text editor"
  homepage "https://gitlab.gnome.org/swilmet/enter-tex"
  url "https://gitlab.gnome.org/swilmet/enter-tex/-/archive/3.48.0/enter-tex-3.48.0.tar.bz2"
  sha256 "265d83da04ea924838356d4944ce378ae8c97500adde30d4ecad32a9ef6b9903"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/swilmet/enter-tex.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "588c9b0d779340bf1199948718c8f6af5fe3c23c9801d34755c19d24bac6b7cf"
    sha256 arm64_sequoia: "77272cae991848eb62ccd74429963ed19fc0ec0cabd32ee6775e05894523e061"
    sha256 arm64_sonoma:  "cf804f346bb3fcecc2e03767b05a1b9a4121039ddfeed3e08aa914cee53a0b57"
    sha256 arm64_ventura: "85ad277e1f16e7f37cda75d95b6c296b00422be3488e800dd4b7fc02b71c9f31"
    sha256 sonoma:        "4a041cad047351efc942cd2f841f9b02f346e03306920208dc0d7cb653fb3072"
    sha256 ventura:       "ba725e1c40a557f0985c3bfd5e21cfb851c86972ecabbfdd23f7e6911ae4d71f"
    sha256 arm64_linux:   "418c853dd0ae96c71cfd0eedc7f6d91124abbae93ec1adf2f6baf46bd416d707"
    sha256 x86_64_linux:  "310deadf40820f6c3b6124a8143844fe86b3165b2b6d9b117e28bf6eb4582c68"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build

  depends_on "adwaita-icon-theme"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libgee"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["DESTDIR"] = "/"
    args = ["-Ddconf_migration=false", "-Dgtk_doc=false", "-Dtests=false"]

    system "meson", "setup", "build", *args, *std_meson_args

    # There is an upstream bug with meson to build gtex,
    # https://gitlab.gnome.org/swilmet/enter-tex/-/issues/19
    # and so build the Gtex-1 target first, same as arch linux package build.
    # https://gitlab.archlinux.org/archlinux/packaging/packages/enter-tex/-/blob/main/PKGBUILD
    system "meson", "compile", "-C", "build", "--verbose", "src/gtex/Gtex-1.gir"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-ft", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"enter-tex", "--version"
  end
end
