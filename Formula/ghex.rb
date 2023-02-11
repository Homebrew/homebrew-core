class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/43/ghex-43.1.tar.xz"
  sha256 "a54b943efe42010a9c12e4dcdadb377bf36c94c3800778b8530c3a834409dcc7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "74e151da0528935da9049a5dd39123190d781a3c063bc98d9415618062bad480"
    sha256 arm64_monterey: "402113e3b5f93b1792663309f438dc9d27b9509e5ef3242514a75a43462560ef"
    sha256 arm64_big_sur:  "dd4c724e0c28832d8e15720d3aa128e570a1492e0022c4d1b13d41f81c614f2a"
    sha256 ventura:        "c0438c0eb753283effd90008a2e4d980f0102dd098fd26c32ee2bc6c422695b3"
    sha256 monterey:       "2c1c3e16266e772f2cdb4bf59247c7ff921f3394ab031528d719078897f3b997"
    sha256 big_sur:        "96265a286a5ee0db13a704dc2bf09417a694797a1b3362b90aa4a24def42e1b3"
    sha256 x86_64_linux:   "062720289937674dadc9f42fcc739292e89e54b0189820f2a8897e969672971c"
  end

  depends_on "desktop-file-utils" => :build
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
