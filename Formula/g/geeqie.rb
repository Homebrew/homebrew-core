class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.6.1/geeqie-2.6.1.tar.xz"
  sha256 "164b768b8a387edf654112428adb8fd88c265c76b7bc84a490158e6923da3a55"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "57187ed489c519d3bf2c18748c34aa8f2779d0520a1dc91e10e1345d9db4b78a"
    sha256 cellar: :any, arm64_sonoma:  "836a53db58ed0e5116998776114e13295eaaecf5d433ce7f161265fa38fe291f"
    sha256 cellar: :any, arm64_ventura: "8ca00e0ee46ef42feb7dd5e12d482c399db5ec187449ee2030929f32e2e2923d"
    sha256 cellar: :any, sonoma:        "b197558b1aef973b8ffdec496d148966ae4337856085fd32419ad4daa2e36b62"
    sha256 cellar: :any, ventura:       "d5242f92b22587a0dfdef40843792903e35b919e07ab99bdbcba4f8a9bfb21ec"
    sha256               arm64_linux:   "657987d0ad5967374c8be7337ce7d5b6dde73f1f1c9e883ba388e4073927c2e6"
    sha256               x86_64_linux:  "9c95ebba3f4d8bc4ca91db9e258ce52ca193a0f3d10c134cd93c52f2df28b0a1"
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
