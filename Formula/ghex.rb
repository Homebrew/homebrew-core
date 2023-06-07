class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/44/ghex-44.1.tar.xz"
  sha256 "404bdf649eaa13922a80ae32f19fe40e71f0ee0f461c45edac72888a00ead6c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "b24850225e3ef5acce621a865092640176c258cc6f5a0d20025c2b063ed8df26"
    sha256 arm64_monterey: "bff53ad2a98f8acd5a90f6175f738eafcd52a87a2440cbf15373715e2a267e0f"
    sha256 arm64_big_sur:  "71d00373e2bd1046261ea16a32d96315945ec4694ef5565a4bfe337891bf7324"
    sha256 ventura:        "cd5d6b72c6b5f69f591c09b1df69233041b8d4c06182977793488b4368fb55c5"
    sha256 monterey:       "17a2c88e096f50a272d00b610ca0ab31cb936bed869ef2b19bc2960ee6c6acf1"
    sha256 big_sur:        "b15ad9b195d096a84814be302aabd77678110bdab98e81f013c470303b162d70"
    sha256 x86_64_linux:   "e2345dd7567104840a79161f8e18d55d8df90c962409d4c135b71ae088d07225"
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
