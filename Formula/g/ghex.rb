class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/50/ghex-50.2.tar.xz"
  sha256 "4134d2318b2aaadc7ab3dd33e07d7e6dbf31663cef5bfd2d21ba90ded5f584ab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "e351a1a6916c1a45dd8930072485a7986cc257ac791d9bbd6e950237b6f47d50"
    sha256 arm64_sequoia: "1c4be21fabd4188bf6cb2b8d1397295bffc4886d30a20d82114b02c3489bd135"
    sha256 arm64_sonoma:  "2832ca071805ff523f6358e354f653de87df8b27334bda79fbcddf7375e7a1fb"
    sha256 sonoma:        "48a371b83b41e736bfd09427fc6dc76dd14c92f89a47b7b88713529718bf8fb0"
    sha256 arm64_linux:   "449cd325ba6cb8f2dc37974110e07d34e3cc1a02f7b6d776332810504802f00d"
    sha256 x86_64_linux:  "9a4a3c6e73cc8ed61bd8bd754ab021d972994519ffb9216fa930e271aa292628"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{formula_opt_bin("glib")}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{formula_opt_bin("gtk4")}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"ghex", "--help"
  end
end
