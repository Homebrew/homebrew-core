class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://apps.gnome.org/Baobab/"
  url "https://download.gnome.org/sources/baobab/50/baobab-50.0.tar.xz"
  sha256 "573c84f15f5f963a440500f6f43412c928ac2335f6b69dcb58f1a1fe5201024b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "201ffa3b00055221be59e714d0b9d550ece6b77a811139346b64b4204107b3a0"
    sha256 arm64_sequoia: "f68026988ed1215d921954b1e3d837ee275b3f091a8fb0569125f4b2980006dc"
    sha256 arm64_sonoma:  "9ba5f0c502674bfe24a96db55fc8ee8b794c86d770003011fa2c30fc64b53c87"
    sha256 sonoma:        "2fba77061cb9530f9cae2a1a69e7f3bb9b9fdd7ca0d832a9e39554ba17e689e1"
    sha256 arm64_linux:   "3b646e6805843441709711db33468ea9ddcaab2a1e916244df8e2246a670afc6"
    sha256 x86_64_linux:  "a4625726683a287c735411240865f6abcf30b8b4da252476215d63fe9db203c7"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https://gitlab.gnome.org/GNOME/baobab/-/issues/122
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
