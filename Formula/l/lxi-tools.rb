class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://lxi-tools.github.io"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.8.tar.gz"
  sha256 "ef9d013189c9449f850d467dd35ac3840929e76a888cdb77e0edbce067da0b2d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "5d9424421034893f420799c531a9732e9719d5f69798d656e40b155f276b9ff2"
    sha256 cellar: :any, arm64_sequoia: "05e3f24a9480e787374399aff7fc7e544ce0722ff0ecf8f6dd02295f8a567da1"
    sha256 cellar: :any, arm64_sonoma:  "bef05fe16efbfeaa41efefd2457d39175b25840cd163c9b93c2a5b7ed97c8b27"
    sha256 cellar: :any, sonoma:        "9b441cf6d443718d7b74c6c67084d0693b4c5805e82a112ec502c2449e36ebe2"
    sha256               arm64_linux:   "83b364ea61ccc15ee0dc5a2b35a9b740db3b396664e5cd42a9635dc139d72b2f"
    sha256               x86_64_linux:  "3b5754ad16e9b2d57c95f78593f05fa0a9c10a53258895fa9bce169192720427"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "desktop-file-utils"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "liblxi"
  depends_on "lua"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
    update_desktop_database
  end

  test do
    assert_match "Error: Missing address", shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
