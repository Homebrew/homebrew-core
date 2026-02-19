class EnterTex < Formula
  desc "TeX/LaTeX text editor"
  homepage "https://gitlab.gnome.org/swilmet/enter-tex"
  url "https://gitlab.gnome.org/swilmet/enter-tex/-/archive/3.49.0/enter-tex-3.49.0.tar.bz2"
  sha256 "cd83dc75c36edcc9fc53c27b092796f0c1df1c4e1b36a15516a56e7aab48f31d"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/swilmet/enter-tex.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "d4f3f78d741b6b74ee5d5614d371083d7170d3632831fbeba0bd4b0860c0e09a"
    sha256 arm64_sequoia: "54bc5763249a15db71b9bcd7c99130d1c9792bacee307649191830c1047fb3dd"
    sha256 arm64_sonoma:  "a03bac81e59688fe5cb8300fe1d9a98d54016ae68437d265bd3efaa2c04361d0"
    sha256 sonoma:        "e5081612b8cfb7600fd27ea1f3d10effb7f9dda93d23f9cd468c37bca10dadb2"
    sha256 arm64_linux:   "62c99fb21e459a0035af2fe1f7ff9a26578d0050e394a80a6657571945a30da0"
    sha256 x86_64_linux:  "76fde6a58a4d9e38b0db038361296fc5c1b435b58cbdc2d33fdc2c2369928a98"
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
