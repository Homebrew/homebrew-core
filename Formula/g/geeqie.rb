class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.1/geeqie-2.1.tar.xz"
  sha256 "d0511b7840169d37e457880d1ab2a787c52b609a0ab8fa1a8a391e841fdd2dde"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e6e1462c3a54b425aa4f75fcb7601689a4748dcde4eef5a65518be2974f67790"
    sha256 cellar: :any, arm64_ventura:  "5dc3d8108dc89c601254d03d2fb205ff913677d3a510aab498a54002d508e2b6"
    sha256 cellar: :any, arm64_monterey: "6eca40757daafea7f1f3263f8c77ce86a338a72a4f80dfa5be46d437d142ee17"
    sha256 cellar: :any, arm64_big_sur:  "70c05cc4f22c37536d25349b014107476ff280e11424f4775425de3cecf71e7a"
    sha256 cellar: :any, sonoma:         "d8d26f59d6c40d0d2a9dcb2f23e9c72d5694ce75a68d9615caf76f5182152871"
    sha256 cellar: :any, ventura:        "7666cdb78780d0c00bacebc4a31009ca5fea4bfdd4b0cbca759eb8503a44b84e"
    sha256 cellar: :any, monterey:       "b666a29f80ff281e9ec6911462a2bc61e2dd0108d272829e5448c017e588f23b"
    sha256 cellar: :any, big_sur:        "17265308454403a649990cb8fc949e5fdbd46197ad9c9f3ef8d8a4befa87ac94"
    sha256               x86_64_linux:   "2cdba76dac3d5aff7cd0941b825b4e333ceec0096e7c17f1bc92319851d85a90"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build # for README.html
  depends_on "pkg-config" => :build
  depends_on "yelp-tools" => :build # for help files

  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
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
  depends_on "libarchive"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "pango"
  depends_on "poppler" # for pdf support # for video thumbnails support
  depends_on "webp-pixbuf-loader" # for webp support

  uses_from_macos "vim" => :build # for xxd

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
