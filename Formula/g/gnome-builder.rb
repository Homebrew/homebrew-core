class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder/"
  url "https://download.gnome.org/sources/gnome-builder/49/gnome-builder-49.1.tar.xz"
  sha256 "3b9e4798388f959e1032c6ace4a5fb7b4e588b6339fce4c22ec26abe869f8a2b"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "51c268898ad4f9a47246a4f52eddf2396e3ae323133939926e570243ac9ade87"
    sha256 arm64_sequoia: "3348a21bc3347851241323677d1f4eeee4e670d600afbb3b9f0bdbdb0fc2d175"
    sha256 arm64_sonoma:  "603f2bb5ae60018e737f72a08057f8289206f919f79720d09d9d6d5b865ecf95"
    sha256 sonoma:        "daad91ed181cb573fc37f6a5d08a49ae3e281485ed37a5a84ea1b56bc5b024d0"
    sha256 arm64_linux:   "61a635c630195e076973cbbf8a949bff56efe573426346d2920dd359e6ae0e03"
    sha256 x86_64_linux:  "b34b4becd41faf7d788209bbfdae051807c2d8ac53c700a044d618fa6c4a8831"
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
