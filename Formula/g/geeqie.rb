class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.1/geeqie-2.1.tar.xz"
  sha256 "d0511b7840169d37e457880d1ab2a787c52b609a0ab8fa1a8a391e841fdd2dde"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7fb033e7bf5aa7091d2565c3e5ddcc370d746350ceac5d31e398e793329ea586"
    sha256 cellar: :any, arm64_ventura:  "e4da878efe0501c2c168f62a94d7f9428c6903b8870f5ac2b0e84bb5c40735ac"
    sha256 cellar: :any, arm64_monterey: "80737df11fd745628fff2de03f7dac47d0fb27224175e371cad022ccfd6ff312"
    sha256 cellar: :any, sonoma:         "1d7204f0c87bf347ef45b7e38aeb0e4851d25858981317b72c292763df67a156"
    sha256 cellar: :any, ventura:        "169db600101a6d295cf95b44c39f30a7d1b6b0ffc9fd4804ddb381840c17af8f"
    sha256 cellar: :any, monterey:       "294af6ea7eb184b1d67bc28eacc5d79eea8f0de3396c7cdfe2c7db4adfa12c70"
    sha256               x86_64_linux:   "98073c8b6bb49dac62016ed25376bc898f2ba4a19355ea0091f3452448c9803a"
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
