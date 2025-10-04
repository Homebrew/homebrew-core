class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder/"
  url "https://download.gnome.org/sources/gnome-builder/49/gnome-builder-49.0.tar.xz"
  sha256 "d45990db681f95ee2277be4fa9f2964982707dbdf30130a0bde70234b379f562"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "760b005bf5f4c83a86467b2934a3ab0829725d90ce116fc5f9938ab905dde48e"
    sha256 arm64_sequoia: "5e02c752c2cf210990b41fc2b696db65bbdb997914b85e0f85fa9b87810b7919"
    sha256 arm64_sonoma:  "9cc9503449a389f7221b87d01ca9152107cc08a5b511ee873bb3d67d873ae8da"
    sha256 sonoma:        "e1fc77710d3e285c8763a5cd57783d4c7e3d3dd12fac715847fc05498d651cdb"
    sha256 arm64_linux:   "116e946ab21aa764a1e11dbbe9424cf1393dd24c2e2db3c929a65488815bc801"
    sha256 x86_64_linux:  "3f17b64a3ec7f93f455dc4a974e26b666592e53021f5618e1a9913b657d5d5d0"
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
