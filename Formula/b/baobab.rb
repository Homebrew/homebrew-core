class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://apps.gnome.org/Baobab/"
  url "https://download.gnome.org/sources/baobab/49/baobab-49.1.tar.xz"
  sha256 "6243c92002be7e91f5decd249612face2a4a12d3742afd88b086a94b875dffe0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "5e0fb8ca33c5d696ff06d46ab07ed00f2663af78c74048472db73af6a67f6ea4"
    sha256 arm64_sequoia: "0239323f900c17acde7297174a4faa6cf5a33df95a3fadddf2c52a651a945bea"
    sha256 arm64_sonoma:  "ce249f598346bd47e1e347486c3db96eff3f368c34c11414a78f46d722d75cbb"
    sha256 sonoma:        "7f0aaa55b302393935ecbcd74e598c935b66e9858ede29b607babd10cbfe8776"
    sha256 arm64_linux:   "481887eb26edcb3dba13eca6482f5e26bbffadb12c577e592f4131b602e44f07"
    sha256 x86_64_linux:  "0d503eafc3495343c4582450ba83ad9579d990162d6da4522c30ee29c56366f7"
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
