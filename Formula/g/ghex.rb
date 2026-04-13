class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/50/ghex-50.0.tar.xz"
  sha256 "8325ca4b1fa75375cf8951e62f867fa6a842822c2dd5a46a9877360818b30212"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "9025288811efc627d6a16727f16310bd7c724b3f6f4e630434ae3f68444e4ab2"
    sha256 arm64_sequoia: "f486dac7dced3452a419339eb788f0c90cc95962cecc9571ce7122e10fbe013a"
    sha256 arm64_sonoma:  "3dbb99e3e6a2ed28e6a87f91d845e20dc0ec7a0a4c47e7e0f176a1ce1d9e3e32"
    sha256 sonoma:        "328b3b8e8b031e335ce2b45e8fc75aa9d3aa9c96c7b407e74017baa27942737a"
    sha256 arm64_linux:   "f00a8f47a02134fb42104eee47a1ea5314bc9fb67407a88bc0e767e580f1de8c"
    sha256 x86_64_linux:  "058054534869bc6abf483a87d82bb6b1fd210d5e4d2432307f11040d3a57e1bb"
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
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"ghex", "--help"
  end
end
