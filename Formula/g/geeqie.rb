class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.5/geeqie-2.5.tar.xz"
  sha256 "cc991c9d4c78c58668105a15f7ece953bfc21b6b78cedc26ccbaaee6a12b8952"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2ba6af24f586147bdcae30c0cbb338faba1a80c904f78314afa76c2d944ceb04"
    sha256 cellar: :any, arm64_sonoma:  "9215bb9a5e1e2c6acba36a122821ca28edb43521a901407fb81947f3857de00e"
    sha256 cellar: :any, arm64_ventura: "96f1a9e5afdceb7cd6528fa0219aef930e31414ba6b887aa04a06b93dd0d5dea"
    sha256 cellar: :any, sonoma:        "fdbf605a9b19a52011a500a07978cc468648939622de22f0c4416b9b38e21542"
    sha256 cellar: :any, ventura:       "580834b9d461fba3a84bb36c4fa854139de828c4ff46d544b14661dd8b32fd12"
    sha256               arm64_linux:   "4b5fa1aa367fc587d8d2eb8ad3341453a9381886888b8c50961cb726788ca6b0"
    sha256               x86_64_linux:  "a8a49ff2e1f2662ade21392ba02e296cffb0b5cee6b7f8906446701323031824"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build # for README.html
  depends_on "pkgconf" => :build
  depends_on "yelp-tools" => :build # for help files

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "evince" # for print preview support
  depends_on "exiv2"
  depends_on "ffmpegthumbnailer"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gspell" # for spell checks support
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libarchive"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "poppler" # for pdf support # for video thumbnails support
  depends_on "webp"
  depends_on "webp-pixbuf-loader" # for webp support

  uses_from_macos "python" => :build
  uses_from_macos "vim" => :build # for xxd

  on_macos do
    depends_on "enchant"
    depends_on "harfbuzz"
  end

  def install
    system "meson", "setup", "build", "-Dlua=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"geeqie", "--version"
  end
end
