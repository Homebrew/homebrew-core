class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.2/geeqie-2.2.tar.xz"
  sha256 "899ac33b801e0e83380f79e9094bc2615234730ccf6a02d93fd6da3e6f8cfe94"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8e7c6bfe2f4c8cce1cdaa10c47106f17eb84c93028fde80c4102f700044e2088"
    sha256 cellar: :any, arm64_ventura:  "1a01f36f93c9fab3462304e732f7b3e9e0ff0d82639e2deb76fe2f253dd907b3"
    sha256 cellar: :any, arm64_monterey: "d6ea504bc3c656364415bb4eec33da1e8cbc941e3cf44b6221cebd384d09712b"
    sha256 cellar: :any, sonoma:         "52b8948c7aa8c8c3fcf63d41d2a19d919df5ebbfdd163ffb0cc45aa66c3f9268"
    sha256 cellar: :any, ventura:        "0b64010355e24609b46c665a8b7a05a0d46b574b366a7d9cc02e58f2cd104028"
    sha256 cellar: :any, monterey:       "a5171f80a9c9111a8a019d4528a802507c060659486338d5e4d88c6b695c03d9"
    sha256               x86_64_linux:   "5141389d7b1e37e34957b7eb1c2a4d0bbcab29e7a2d25a80d110cf02b5ed8311"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build # for README.html
  depends_on "pkg-config" => :build
  depends_on "yelp-tools" => :build # for help files

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
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

  uses_from_macos "python" => :build
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
