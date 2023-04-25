class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/44/ghex-44.0.tar.xz"
  sha256 "58aa47cfdbed1280a3c131951c1a24596129404a0b0d347a3dbfffb6ff683976"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "b6c4ad82000bf05c1b42e89e1a2648a22c1097cc0ef22d9a09b97e3297436f6f"
    sha256 arm64_monterey: "8e34eaffb57a960dc5155c93630d81279035021fa465b8e9addd4136f9cc3f6a"
    sha256 arm64_big_sur:  "6198b5dd902d8fec40588899796144fcc42ab0241c731ecf73fc11a92940dde1"
    sha256 ventura:        "7e48578e94e9f3cbbb5cd161e215579bbeacd3f1797b22b9f21b0b2205f12a93"
    sha256 monterey:       "0849cb32a2894d6d7122730c45106aed4500c8285042b0147154b9823367aa62"
    sha256 big_sur:        "838fb9c7bcae65fd73ceb46f96ce2982465d671c5661ae6e2d0901fe3d70bbc0"
    sha256 x86_64_linux:   "0d65e151fdf50d4b44897054e39411493cb42b2766ee241f9b2cd107c2a1831a"
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
