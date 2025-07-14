class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder/"
  url "https://download.gnome.org/sources/gnome-builder/48/gnome-builder-48.2.tar.xz"
  sha256 "ec1280d47e814a313b74cb927d5a059380544aa0f56e87552978397d6c74cc63"
  license "GPL-3.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "9934f8098e18b136e452237eae4f6e10177c2a166642ba999c143451779b12e1"
    sha256 arm64_sonoma:  "fd8400100dbe507d5569396301144f8b58b4d510d3b80a841e6f9639f6c0be3d"
    sha256 arm64_ventura: "2199f4eb7e4fce3754b35f7dcc4cca6eeb63c8907584753d4d50f5c8be2e6a61"
    sha256 sonoma:        "7170efaed354f6c01d40dc083049408b439f3c94eddc34d971546e2dcf060975"
    sha256 ventura:       "062b72bd73b4fbb2ce9ea3b2ccd9931766b26a6c52b6d3f6e815c1f11f52c16c"
    sha256 arm64_linux:   "765c8c5e448046e48918a3f5b58af3771e377c928f978ef50a850d564f1a1b9f"
    sha256 x86_64_linux:  "7de348fcc6ee8a995dfad923135dc64df3b742cee7083e8efbdf39f6b304dcac"
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
