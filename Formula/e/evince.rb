class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/48/evince-48.5.tar.xz"
  sha256 "0c7aba9485d0b6fb9f3e0ee75be916544744dc2ed9d58a2f9936a2e0434ac4a6"
  license "GPL-2.0-or-later"

  bottle do
    manifest_sha256 "f4ddb44a5f80400a458330f528c0a884848f166c403dcbc613668628281f9880"
    sha256 arm64_golden_gate: "46463020ba0f562b6fe94d836fcf4a786e9e72661045ed80de2e5fb9d07310c2"
    sha256 arm64_tahoe:       "b1d5f9ad6fab5f058ad3940b413441692af461bcdaf44dc541af04cd49a8d4be"
    sha256 arm64_sequoia:     "6d0a8b81ffdab3b822401aae5f00437b800afe058e91c9622dd0551db59f8b14"
    sha256 arm64_linux:       "3c361b443ce0f91ac9e53b80dfda98a92f952e24b32e1974f37670bd7c11dd51"
    sha256 x86_64_linux:      "815096b5b4d0f14b68a76e8b00ae65a9609346b8ea3357db91cc3626f9ad653f"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "pango"
  depends_on "poppler"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # `test-ev-spawn` needs `gio/gdesktopappinfo.h`, which macOS GLib does not install.
    inreplace "shell/meson.build", "if gio_unix_dep.found()",
              "if gio_unix_dep.found() and cc.has_header('gio/gdesktopappinfo.h', dependencies: gio_unix_dep)"

    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dps=enabled
      -Dtiff=enabled
      -Dxps=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Ddbus=false
      -Dgspell=enabled
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
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
