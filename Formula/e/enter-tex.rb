class EnterTex < Formula
  desc "TeX/LaTeX text editor"
  homepage "https://gitlab.gnome.org/swilmet/enter-tex"
  url "https://gitlab.gnome.org/World/gedit/enter-tex/-/archive/3.49.0/enter-tex-3.49.0.tar.bz2"
  sha256 "cd83dc75c36edcc9fc53c27b092796f0c1df1c4e1b36a15516a56e7aab48f31d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/swilmet/enter-tex.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "642a39bd8896727469dc8e18dee0fb1a78670445b9260c8448735d2ff5224d05"
    sha256 arm64_sequoia: "91eef2c5d6cb6f7c390598ec473597f8483becb0d8a5412bc4f9e2e6cc8eec04"
    sha256 arm64_sonoma:  "1523b7a53310d9e1720e7c651339823cde5aaab43eac1a68174fd5447c5bf47c"
    sha256 sonoma:        "f34d9cb07ef686285a7668f6ed66ff9551ee34462597f13064a4359038f87879"
    sha256 arm64_linux:   "631738d30fa2e7bb50cce137cfa5232d9961c631e0d9777fced217229bed1e95"
    sha256 x86_64_linux:  "24376a6463bd801fccafadafa5b1e6a7e76f8021fcd50ea7f57ee9bb5b135132"
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

  post_install_steps do
    compile_gsettings_schemas
    gtk_update_icon_cache
  end

  test do
    system bin/"enter-tex", "--version"
  end
end
