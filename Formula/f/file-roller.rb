class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/43/file-roller-43.1.tar.xz"
  sha256 "84994023997293beb345d9793db8f5f0bbb41faa155c6ffb48328f203957ad08"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "14e19ab1d9409ae2d45574f767bd29e7ab39a345d1cead6c0bd9ee82fbc8d679"
    sha256 arm64_ventura:  "00594e15981fa0051bd32ebd96d91a4c0abe0380fdc6c427a1ef9cf0b92477c5"
    sha256 arm64_monterey: "0b8aa3451780dac8d8d44a2f338b46c7ee6b49d4d2b72a61c287bb40cd125851"
    sha256 sonoma:         "28d1e69a91240040ba4b01dbbb4f59e3f211329937942b35d1ba2e4cae716261"
    sha256 ventura:        "cb4cfb5d58c48bae9dc0f389889b0c5a2675114e572fd6adce3b16c48c93d659"
    sha256 monterey:       "b97de5e9eb8f1853cfd2a3ec1d639896e7579e34668a2bce489c58140a5b6e38"
    sha256 x86_64_linux:   "2ea0ae4fbd4f6164d20b818f4534025981db61361cb1e47bb84e49548f7d8be9"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libhandy"
  depends_on "libmagic"

  def install
    # Patch out gnome.post_install to avoid failing when unused commands are missing.
    # TODO: Remove when build no longer fails, which may be possible in following scenarios:
    # - gnome.post_install avoids failing on missing commands when `DESTDIR` is set
    # - gnome.post_install works with Homebrew's distribution of `gtk+3`
    # - `file-roller` moves to `gtk4`
    inreplace "meson.build", /^gnome\.post_install\([^)]*\)$/, ""

    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dpackagekit=false", "-Duse_native_appchooser=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end
