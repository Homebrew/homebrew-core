class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/50/ghex-50.4.tar.xz"
  sha256 "e2bcf62438edaf04ca961aef8dafd35a2d208aa45f00ee557000b37214c0972e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "344b6ea9969d228233571963347ddee13d8ecb5b8d3ae14441ff6429cd7a5470"
    sha256 arm64_tahoe:       "e2037a9096186b0478c1b8b7f1456dd314be795510fb0114d5b0ce69cf9d0789"
    sha256 arm64_sequoia:     "8f0fbe39e84ff1151871607a4a73864e4ec49b18eabb0a6b53d7c936fd16405c"
    sha256 arm64_linux:       "5061a2df72bf3dd8ae4cc16f0df9b14118f1eb035d72a85ff0955a5ebbe75067"
    sha256 x86_64_linux:      "17d5f4a247780b3dc91a5c483293cd267cea5263e0f67495cc2c06315879df53"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    system bin/"ghex", "--help"
  end
end
