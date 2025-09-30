class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://github.com/lxi-tools/lxi-tools"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.8.tar.gz"
  sha256 "ef9d013189c9449f850d467dd35ac3840929e76a888cdb77e0edbce067da0b2d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a6f6bda40e33933f6bc825a28e9a3622a1c5604cf6084e39e7afa1565c0a8d0"
    sha256 cellar: :any, arm64_sequoia: "be6069943c2ea42d4bbe08093d302097c6b845daf5715a3c48fe53fc6af9d613"
    sha256 cellar: :any, arm64_sonoma:  "aa7dcfd5abb6be73394e6de4e178852da17b4d77c9e2ac92e0526e166f8aa146"
    sha256 cellar: :any, arm64_ventura: "2d6da719bc67d07ecaa3c90eba4adfb710287f1a658dc6f430c7218ca47a5cfe"
    sha256 cellar: :any, sonoma:        "2072bc9693447a72bf3fa53f4b7fe44e1eaae6d86c7f451b51005a5613b20182"
    sha256 cellar: :any, ventura:       "1007e5d715fa7d3dd46a13354eb0403e21de7062914650da8ebd4b0d58011678"
    sha256               arm64_linux:   "339c24ce23a508409b7ecf4a42e7581742e9b4a12be98dadc33efc7ce5a26070"
    sha256               x86_64_linux:  "ec4ad53dd83db6db87bae92862f289e2e098aabaf94a2c1f056562e9b8b6293f"
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

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
    system Formula["desktop-file-utils"].opt_bin/"update-desktop-database", HOMEBREW_PREFIX/"share/applications"
  end

  test do
    assert_match "Error: Missing address", shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
