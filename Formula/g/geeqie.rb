class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.4/geeqie-2.4.tar.xz"
  sha256 "f2b7d1290786fdd1afec09bbe0217f327ff1ee7c80363563e8a108d03aec77da"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f4b5b7ab7d532f9ffd874084a95dfcc9fe72e97fc99268f2d2e6dbbbb2c46494"
    sha256 cellar: :any, arm64_ventura:  "339ff3d55396d64b25fe06f2d0ac9aa9227860ffc9580e2e3f97f60bc9424c01"
    sha256 cellar: :any, arm64_monterey: "eac604d18c097e6ead04402af97208018ae0bfbbdce2fa6611c37ec251a872aa"
    sha256 cellar: :any, sonoma:         "1a61c133caf1bb8053bf0f7fcd721b70b31edeac453cfd461f6d811f075d6e82"
    sha256 cellar: :any, ventura:        "ff8c7decf730f08851b01d817eee846a8090b9bc7971893785e15320f0bc5193"
    sha256 cellar: :any, monterey:       "e47bcf35bc04c406d80e37633357668e89eefd803b04091020c770386543cf4d"
    sha256               x86_64_linux:   "f0ead1a37d0842bb95b63fba36b56f3ea2668f017b70f10f5467586819ca3600"
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
