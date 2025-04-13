class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder/"
  url "https://download.gnome.org/sources/gnome-builder/48/gnome-builder-48.0.tar.xz"
  sha256 "7afe9a7a3b3c6621768bc46a61d698dd788b3653fb46a708238bdccf4de67ba4"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "b80a184ac8b15c2154463ed54281717ef1d40f0b866c448bef83da30c9cfc81a"
    sha256 arm64_sonoma:  "c8d8d402a3b822c48bc9d61f310b46fb795809a0b8d7632c0ba52bc983c88a3e"
    sha256 arm64_ventura: "d6050b679134150db7ba333bf848dbec68d9d726427b50f27949d43f7a308e16"
    sha256 sonoma:        "6f96def97df25a2b8eac97a66042177c1561ae57b80f5e1b278f4cce974be07b"
    sha256 ventura:       "98d8148fb97ee4762113d60bf7bc5bc9a143eb9cc61932c3aa09d9d92f9b0815"
    sha256 arm64_linux:   "b91cd3072e22acd5cf59612f20d014abfcd246b05b47077038c4e7674ccace16"
    sha256 x86_64_linux:  "082a37dd3a82981428c00a78a6f6c077ee88c3626f7f247531add1f5b6074395"
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
  depends_on "llvm"
  depends_on "pango"
  depends_on "template-glib"
  depends_on "vte3"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  fails_with :gcc do
    version "11"
    cause "https://gitlab.gnome.org/GNOME/gnome-builder/-/issues/2176"
  end

  def install
    # TODO: Remove after switching to Ubuntu 24.04
    ENV.llvm_clang if OS.linux?

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

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    assert_equal "GNOME Builder #{version}", shell_output("#{bin}/gnome-builder --version").strip
  end
end
