class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder/"
  url "https://download.gnome.org/sources/gnome-builder/50/gnome-builder-50.0.tar.xz"
  sha256 "46d54fd13f4f4bdb6eed7d004b499d0b6d9a76a6fafc68ad16c389953fd92f46"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "82adf89ed4bc89f83e846a4c12a47f3f99bf21ed637b6cc73686dea62a860b42"
    sha256 arm64_sequoia: "119151b397a7577f8726b6f0fc6fde53c59416e2b0d4fba2692b9c23b375618a"
    sha256 arm64_sonoma:  "d01b7896e6b8aadfe27f4d4b867a58341b02f5fac7dccecc1fd2e900a68cff76"
    sha256 sonoma:        "fb653d68e57b0faff070eec61216cec2184d43cd7d0e5b6da67378b4c39fd4ca"
    sha256 arm64_linux:   "61cc2bbf19babe959024f950b4d222ac6741a55a71e1673fdf1f717b311ae196"
    sha256 x86_64_linux:  "76704c6bea1bf2317ff332733759cbf8b72235b3d0f55794abb9fa477a6e447c"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "cmark"
  depends_on "editorconfig"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libadwaita"
  depends_on "libdex"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "libpanel"
  depends_on "libpeas"
  depends_on "libspelling"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pango"
  depends_on "template-glib"
  depends_on "vte3"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  fails_with :gcc do
    version "12"
    cause "https://gitlab.gnome.org/GNOME/gnome-builder/-/issues/2176"
  end

  def install
    # Prevent Meson post install steps from running
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dplugin_flatpak=false
      -Dplugin_html_preview=false
      -Dplugin_manuals=false
      -Dplugin_markdown_preview=false
      -Dplugin_sphinx_preview=false
      -Dplugin_update_manager=false
      -Dwebkit=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    assert_equal "GNOME Builder #{version}", shell_output("#{bin}/gnome-builder --version").strip
  end
end
