class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/46/baobab-46.0.tar.xz"
  sha256 "ce4def5c82d05671a5009f7bebcf85ac98675d9d8160d28ad9181b269a72e37c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "976ee19963aca9875c5f2535890982f0ada6c3859f9f219974828fdb5d587c96"
    sha256 arm64_ventura:  "4536d768a8ce57ac327a8807b5a915426b84246fe71a60e670fc7e9eaf8919fa"
    sha256 arm64_monterey: "1dbcc7aff96c0e13e0a3f111dcc224c20a18f5a994bc146aaa59a882fa1e17cb"
    sha256 sonoma:         "86c04921a9dd7e05050a2337c66ebfce846b423fe8139bb0d36ce2cc1d273f0e"
    sha256 ventura:        "eb5964c8ad54f6eb620f13f680db20fd4811049a1c5b40d8c3a3b4641726c1e5"
    sha256 monterey:       "d96c43667ebf5e04f5e2757134c6e123a6b0b48fa9a638ab461d9c021b18b946"
    sha256 x86_64_linux:   "9619add2ac0cd8952ff8de166e3c871ee3de5981551c547b268e2ebb60f14b21"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"

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
