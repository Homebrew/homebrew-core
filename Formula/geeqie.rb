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
    sha256 cellar: :any, arm64_ventura:  "be131da5651dbaf7bbebc05071370964ace01fb7952318d77880e989571943ef"
    sha256 cellar: :any, arm64_monterey: "21cbf95d6c94ee2ca0a829892af45658361648d06163a6459d0f341066430731"
    sha256 cellar: :any, arm64_big_sur:  "b87ef020a355a72de1b5678d0777f6437600358e8f727db1271ebfeba5d51da5"
    sha256 cellar: :any, ventura:        "dd7be8ecba39d584a89541517523c47050db8595d3551fc94dbe5934511d1cc7"
    sha256 cellar: :any, monterey:       "238386bb528cced0050a095c89973d0edf4cf04abba612cd5778c1ffc36ea6b4"
    sha256 cellar: :any, big_sur:        "edbd513fa2df92e02ce67adb19e95445744b1ff9c7a8f21d086d547a3c8c28d8"
    sha256               x86_64_linux:   "fdee4ae387afd0ef3ef45a0e09a505aae49d007eff9b2e288fbbac1ae6e61e10"
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
