class EnterTex < Formula
  desc "TeX/LaTeX text editor"
  homepage "https://gitlab.gnome.org/swilmet/enter-tex"
  url "https://gitlab.gnome.org/swilmet/enter-tex/-/archive/3.49.0/enter-tex-3.49.0.tar.bz2"
  sha256 "cd83dc75c36edcc9fc53c27b092796f0c1df1c4e1b36a15516a56e7aab48f31d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/swilmet/enter-tex.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f502eae1452a1ce9a5620c720358ed52ea861bd8fe7b27dacbab42ae6475d180"
    sha256 arm64_sequoia: "2f5789f7d0ff10b42d6d8122144c447f2a240a079ef4410ae8249409aec0b069"
    sha256 arm64_sonoma:  "9fa7b34915c8362871270da348d1feea32c8f6320cbfcfbfb7e10f25a1076eed"
    sha256 sonoma:        "238adf76e9e013bb87e8ee8649c7d5df5e009596f260a06e4e048b0f02c6d4b2"
    sha256 arm64_linux:   "f1655115bbe3e30f31a1b669e58e25861951f62bf8ca195d3e93de5aee3f2c23"
    sha256 x86_64_linux:  "99c7370294d9d727faa05a4dcf1614186284605893cdf47a5c2eb9b3696e616e"
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
