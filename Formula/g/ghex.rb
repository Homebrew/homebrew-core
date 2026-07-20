class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/50/ghex-50.2.tar.xz"
  sha256 "4134d2318b2aaadc7ab3dd33e07d7e6dbf31663cef5bfd2d21ba90ded5f584ab"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "957471fc8f9de5069a456ced4ff60610951ad5ea43e33a12449ab292d7411857"
    sha256 arm64_sequoia: "67e3b91d4282f4d7f2d0c562cddbdff80b7d83d968e494d93eb15d5f5803844d"
    sha256 arm64_sonoma:  "5688bb437072ce3ba0147cd5fdfc972300955f854f23abe28c8e6ed8489d3ec3"
    sha256 sonoma:        "d4d08d567a158880779f2720aa3c1a8f3c988d3f09c94791eec01c3847142abb"
    sha256 arm64_linux:   "1a87be14e37fd89951f929598d336116bdebd0d4d1ffcc0b438eea35b67a2182"
    sha256 x86_64_linux:  "4db5278b159fa77f7c69a97ba1a1345aa7353a48d3899719a64bbe0d09a3e1b9"
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

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    system bin/"ghex", "--help"
  end
end
