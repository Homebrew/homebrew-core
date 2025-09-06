class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.6.1/geeqie-2.6.1.tar.xz"
  sha256 "164b768b8a387edf654112428adb8fd88c265c76b7bc84a490158e6923da3a55"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "39d7bc32802d042aedc21a65c1833a7c3fe66f180fc5f38fcee6023307b286b9"
    sha256 cellar: :any, arm64_sonoma:  "ae50fa9d777727bca0a14724b922ec47d3c8bb5fa3e1e3dee7d37525df2346bc"
    sha256 cellar: :any, arm64_ventura: "fea47463b39098bd175e7e4af069a503ed8910e466bcafaf394bcc29ab344a0a"
    sha256 cellar: :any, sonoma:        "bee342e5c020e966a1e71450b529c5ef7754a2240d0d3aa475437406ffc126d9"
    sha256 cellar: :any, ventura:       "ee00dfc1881b56dea8e624d2931927f0e37e5bf4be22299312c4e1ac9b8f04ab"
    sha256               arm64_linux:   "3957be41b1507e3f0ce3ae6155ba51a942871e872737ab59baafffa7c5aebc64"
    sha256               x86_64_linux:  "7c00d683de1fd5126f9230618ad5b65292983124f77475b023857c485b567ca3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libarchive"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "poppler" # for pdf support # for video thumbnails support
  depends_on "webp"
  depends_on "webp-pixbuf-loader" # for webp support

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "vim" => :build # for xxd

  on_macos do
    depends_on "enchant"
    depends_on "harfbuzz"
  end

  def install
    args = %w[-Dlua=disabled -Dyelp-build=disabled]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"geeqie", "--version"
  end
end
