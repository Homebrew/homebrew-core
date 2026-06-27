class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.7.tar.xz"
  sha256 "67cada96a2409c859f378e82fbe868b0e9c00a69e6b7b885d542c64ea2a1297d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "60e57d73727b41b08539be9d9396d132e6e1893f1306b35db6c3a2cdaf20739f"
    sha256 arm64_sequoia: "db890d8346bab533220917f3bf332919d935a604a0452c02166c3b049d87bc10"
    sha256 arm64_sonoma:  "b56c9f10b2b4f9bbf16bdb2ac431d196ca32a9d6b7ba72c7317d75b0b8e11156"
    sha256 sonoma:        "4810dfc155262b69cbba451184253370760fb307fdfef3b1de36b160d6473f2b"
    sha256 arm64_linux:   "be7a87dc229abd4204dc8317ad04dcb1868018b829c6b2acfdad9182821b775f"
    sha256 x86_64_linux:  "1899d41795fd04556ecf84faf2f05bca75d72425dbeb2b73e1ff894baac5af4a"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dpackagekit=false", "-Duse_native_appchooser=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system formula_opt_bin("glib")/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system formula_opt_bin("gtk4")/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
    system formula_opt_bin("desktop-file-utils")/"update-desktop-database", HOMEBREW_PREFIX/"share/applications"
  end

  test do
    cmd = "#{bin}/file-roller --help"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "Create and modify an archive", shell_output(cmd)
  end
end
