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
    sha256 cellar: :any, arm64_tahoe:   "55a6b7120bf8721d50aefcc67a1c633d37aea9f201bdfcd6df1c8f4013975b80"
    sha256 cellar: :any, arm64_sequoia: "464386cab0126fe009eb1c3a2051427e908e58ad5a015d1136e75532fc6ce5e5"
    sha256 cellar: :any, arm64_sonoma:  "d7337eaf58aa7cf6d0d4d60f8534adf9e44cbdd94a17b8844c1768fa9b19e9b9"
    sha256 cellar: :any, arm64_ventura: "c785fadc1ff45a4692c71809e44b6acd498b9e300767674387084ddcf5e78392"
    sha256 cellar: :any, sonoma:        "4439f2066a4b1c49732f5b23794df73c3c7dcf1c4bd81bc2447b6d83bc8c169a"
    sha256 cellar: :any, ventura:       "8eb1815e1a8a38c5165e0860260aca1d87286d19c9183f63a30033db779faeff"
    sha256               arm64_linux:   "2baa715efecae3bb2953d2bc7e96af74e0b46de0a4e98a4cd61effa32564810f"
    sha256               x86_64_linux:  "31e1b18a469c3aae60e598d03aedebd348d25dc5a4e15844ab8a6871150e9cbb"
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
