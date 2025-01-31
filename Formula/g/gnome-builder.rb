class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder"
  url "https://download.gnome.org/sources/gnome-builder/46/gnome-builder-46.2.tar.xz"
  sha256 "0c857b89003b24787f2b1d2aae12d275a074c6684b48803b48c00276d9371963"
  license "GPL-3.0-or-later"

  head do
    url "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"
    depends_on "gom"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gcc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "portal" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "cmark"
  depends_on "editorconfig"
  depends_on "enchant"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "icu4c@76"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libadwaita"
  depends_on "libgit2-glib"
  depends_on "libpanel"
  depends_on "libpeas"
  depends_on "llvm"
  depends_on "pango"
  depends_on "template-glib"
  depends_on "vte3"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
    depends_on "libxml2"
  end

  resource "libdex" do
    url "https://download.gnome.org/sources/libdex/0.7/libdex-0.7.1.tar.xz"
    sha256 "c0b13e97b340057dc4e7c53f17e5d7ecd310a1fa2abc9a729670f02261a40a9b"
  end

  def install
    resource("libdex").stage do
      system "meson", "setup", "build", *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"

      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      ENV.prepend_path "GI_GIR_PATH", share/"gir-1.0"
    end

    # Prevent Meson post install steps from running, these steps are instead
    # handled on line 92 using Homebrew paths
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dplugin_dspy=false
      -Dplugin_flatpak=false
      -Dplugin_html_preview=false
      -Dplugin_markdown_preview=false
      -Dplugin_sphinx_preview=false
      -Dplugin_update_manager=false
      -Dwebkit=disabled
    ]

    # This plugin fails to compile in 46.2, should be fixed in later versions
    args << "-Dplugin_git=false" unless build.head?
    # This plugin does not exist in 46.2, but on head it does and requires
    # WebKit
    args << "-Dplugin_manuals=false" if build.head?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  # See comment on line 66
  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    assert_equal "GNOME Builder #{version}", shell_output("#{bin}/gnome-builder --version").strip
  end
end
