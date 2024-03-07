class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.3/geeqie-2.3.tar.xz"
  sha256 "cd5cad97f8d0e8c62025334d62688fcf6f82be73a7716c5ca16b205d59b8519b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d4a3771aea12c87fce802264773618c30a640e4a78fd959092d801ae36b6aa41"
    sha256 cellar: :any, arm64_ventura:  "35cfa3654f4fb946f235e9313352daa1b080d3e88c4db8de0272e7e6868bd3e7"
    sha256 cellar: :any, arm64_monterey: "d7642af283fd54acd659f2f32a6406cc341ed0093ab23420ee5c390ef67b6662"
    sha256 cellar: :any, sonoma:         "410f1b8f968e12018f9096a5ab6954b413303ae5e1d12fc2504cf6cab0e9e691"
    sha256 cellar: :any, ventura:        "9053afa0e733d30010de12e2b4126a21859b815432bed0f701e654fe2109dbcd"
    sha256 cellar: :any, monterey:       "1067c13a4b5acf7251cebe6c7ecbbbaacaff8d190586e77dee8a676e266b3c6e"
    sha256               x86_64_linux:   "9913aaa086139df79c834368dcaf6904eb40abc3903314616d25ae8a35050fc5"
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

  # macos build patch
  patch do
    url "https://github.com/BestImageViewer/geeqie/commit/4a9376a78d258ff11e9db33985abbfb9a7be614c.patch?full_index=1"
    sha256 "f9c49cec18cbeb9e764e7ed51cdbeec005f5dbcf99efc26f7e254bb32be1acc9"
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
