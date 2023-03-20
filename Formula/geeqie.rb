class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.0.1/geeqie-2.0.1.tar.xz"
  sha256 "89c1a7574cfe3888972d10723f4cf3a277249bea494fd9c630aa8d0df944555d"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "54b77b6801958469cd339e28a508bf95a615ab74d59155dfb4c2e09ee5c42bc9"
    sha256 cellar: :any, arm64_monterey: "01e5f3db39f9cb38dfbf30a1bdcafa0a3872246dfd8309320ac64f510cbee6ba"
    sha256 cellar: :any, arm64_big_sur:  "bb18481ef2222c516fdab51afc6ecf35be27a81f80b5fd35e46870ca6d5f032a"
    sha256 cellar: :any, ventura:        "f7f68a9cff51eee253f27a6dae3de7bed25b35a7d71e9cf944d3058427ae29a9"
    sha256 cellar: :any, monterey:       "e4ef80750cd324949e8526dcfa38dab732b793a328e0caac2b57c9124d2a2819"
    sha256 cellar: :any, big_sur:        "785cf81d73bbbc8ce6bcc3cc70fa651509b5c31fc1d5e80a44eceda99605b2ea"
    sha256               x86_64_linux:   "f6777859497a9e8bd69ffc7cece9518110044943a3daa5dea866886eccf07d74"
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
