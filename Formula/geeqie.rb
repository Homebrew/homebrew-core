class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.0.1/geeqie-2.0.1.tar.xz"
  sha256 "89c1a7574cfe3888972d10723f4cf3a277249bea494fd9c630aa8d0df944555d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ac70763fb3ebb511318c096abbb73e1f5d7fa40922c41cd31012d1e963e05189"
    sha256 cellar: :any, arm64_big_sur:  "372ad39f0335714ff5f459cd850141cd54def30feeed55ee845fc55f2098f1fb"
    sha256 cellar: :any, monterey:       "ff8f08b56185a58aac2cbb5ba906a86cb32ba0f567389d761f77a72a80ce2964"
    sha256 cellar: :any, big_sur:        "6e971d552d318c0335a555696141afb08aefb9aac05f124e3e3a22bb1c694200"
    sha256 cellar: :any, catalina:       "63d34b4e573a77ece1201658bdf5f458cecc805835f2bf7c681ad6c4988aaebe"
    sha256               x86_64_linux:   "ddb88515ed437fef92099883720bfb4e4fd072175b9fc25a725c4768e40f3444"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "exiv2"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "pango"

  uses_from_macos "vim" => :build # for xxd

  # Fix detection of strverscmp. Remove in the next release
  patch do
    url "https://github.com/BestImageViewer/geeqie/commit/87042fa51da7c14a7600bbf8420105dd91675757.patch?full_index=1"
    sha256 "c80bd1606fae1c772e7890a3f87725b424c4063a9e0b87bcc17fb9b19c0ee80d"
  end

  def install
    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"geeqie", "--version"
  end
end
