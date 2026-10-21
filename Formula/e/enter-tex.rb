class EnterTex < Formula
  desc "TeX/LaTeX text editor"
  homepage "https://gitlab.gnome.org/swilmet/enter-tex"
  url "https://gitlab.gnome.org/World/gedit/enter-tex/-/archive/3.51.0/enter-tex-3.51.0.tar.bz2"
  sha256 "8423115492d28b140b594cf103b3ba0740786bd308e835ce65885f47fef12b1b"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/swilmet/enter-tex.git", branch: "main"

  bottle do
    sha256               arm64_golden_gate: "44a65a569aeabacb64fe050c0cf9a29c88d3e36c6b02b097ea3aaca52a127ffa"
    sha256               arm64_tahoe:       "75c234cc67340d64125d0028d52941f0322cd26586b5e8cbab4df971dc766ae0"
    sha256               arm64_sequoia:     "c6ed7968ff27170a16f3e1174bc7308006c2d9af854adac61937ce70c6ac8f33"
    sha256               arm64_linux:       "d01d7aa15f3f39558476913c2c3fec6f81161753f5a3ff7cf65a9de97b25d885"
    sha256 cellar: :any, x86_64_linux:      "1414e8e0d16deebcc98423bbb5d7b62e9996aab2a006e3f552f90be55133ed78"
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
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libgee"
  depends_on "libhandy"
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
    update_gtk_icon_cache
  end

  test do
    system bin/"enter-tex", "--version"
  end
end
