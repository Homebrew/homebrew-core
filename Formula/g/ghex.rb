class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/45/ghex-45.1.tar.xz"
  sha256 "fb2b0823cd16249edbeaee8302f9bd5005e0150368b35f1e47c26680cacac2fa"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "466f84368ba13eb77df884cd8a0fada643e2e9837556030a8ec5faffd9294aba"
    sha256 arm64_ventura:  "8e157a745d28c5c4f4e3f74dd8b34807e36d01d462528697efd4fa91a2fe1f7b"
    sha256 arm64_monterey: "8dccf86bcddf779f5ebb1b3de87e9a569e3f32abb458b158151cbefbe21faed7"
    sha256 sonoma:         "be2c41e95891226eb1cc104573c9f6d25b74f55f5b51985bab0d9031a4c86ebb"
    sha256 ventura:        "5151b50596edc6a37e88928d0f5a3fafb5ee99672b537058fa160476e7fbbfc5"
    sha256 monterey:       "df03e4ebbdac51b2da7f748e14a9aa9120366fc81a0e8149f20d0f71c4e6466d"
    sha256 x86_64_linux:   "098509a3b3546900fd8a3a14bfe484f689f2266be51eb4100c5f66b2d967f808"
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
