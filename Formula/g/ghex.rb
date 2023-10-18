class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/44/ghex-44.2.tar.xz"
  sha256 "ebecb4c68a37d33937b9ec263c8576df1d8c69ab1c1d3e12d5668fd2007e930b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "030389f2ded957ab4658af0508cb54400afa0401cbdb409ef00c47751980cefb"
    sha256 arm64_ventura:  "2ba3059bb8e360a311c2fc332023595a0b29e932eef11edca72122a5c39bc4f9"
    sha256 arm64_monterey: "9ef887f322df3f5469cc2d1d359fb97aca431ce4d5392db47610b32ff903d4b2"
    sha256 arm64_big_sur:  "ea02821441ef706d84065f4a884ccda5889f4900f109bc8a3f4b58aa1c619086"
    sha256 sonoma:         "0c38d91138eee85bf224b92e45b782ca93e080bab38b0ceb1bb4f8b36ec3addb"
    sha256 ventura:        "201ab7c7ab85be196448a55b63728c4ea0d7cd05dde598db6707f86e9824084c"
    sha256 monterey:       "5863891c05fd85c599001f45b01f0f437cab003dc9293be9e0fc431939be0711"
    sha256 big_sur:        "ec5e064d2afe4c09c99afd9066cc89773579f3ebcc768961210a56e8fa722082"
    sha256 x86_64_linux:   "716fd35c6ea69bc66a28f6c52867f871ba5b00f1be05cdbf2ccc43a53ea62c0d"
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
