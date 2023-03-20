class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/43/ghex-43.1.tar.xz"
  sha256 "a54b943efe42010a9c12e4dcdadb377bf36c94c3800778b8530c3a834409dcc7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "e89bb00de21e8d6de4baad5a729eb08b3302bf56f3c26bbb9b6477df5ecb3d8c"
    sha256 arm64_monterey: "8e6bb76c3d2b861813f7039679d1f28ca4861b15cef77655cdafb995de4efad5"
    sha256 arm64_big_sur:  "153e64489e401835eef827bd273c42f31ca4b6e64a132fa30f99d2922fa120ea"
    sha256 ventura:        "52a672a768aaf74237a7ecdc7f927451b62950af637089e995bc5c54e25819c1"
    sha256 monterey:       "a622d3504f611d7c598e59828940324e367401c9cff887984fdd322dae192cab"
    sha256 big_sur:        "96c3130ffbef361a3da4a9a01197ecc72f6545d7ba819c966d3acb3217f81a33"
    sha256 x86_64_linux:   "7afac9d5abd2de851a521d00d87f4bdd128ca8fa404da6545de4996f13948974"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"

  def install
    args = std_meson_args + %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", *args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # (process:30744): Gtk-WARNING **: 06:38:39.728: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"ghex", "--help"
  end
end
