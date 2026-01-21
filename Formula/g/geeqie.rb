class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.6.1/geeqie-2.6.1.tar.xz"
  sha256 "164b768b8a387edf654112428adb8fd88c265c76b7bc84a490158e6923da3a55"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2a617ffde1951a770a23330a4b1bcaeaf538fc5323b482672fe67df63f66d354"
    sha256 cellar: :any, arm64_sequoia: "4ad851631236ca2215d3603380dbe33b550fd474ddf1adb05cb71a25b434ab43"
    sha256 cellar: :any, arm64_sonoma:  "a9ef828637f5a4094076e1537ce2fdd6365755d59f0e459f750b608746e44321"
    sha256 cellar: :any, sonoma:        "db629addfec006248402bdbdfbe6d13faeb825e8662ee374c13fe88a6bd3e9c8"
    sha256               arm64_linux:   "a85fbf796de18ef670528631a5ffa2c826aadaac0c994d4f4f5c87960e8077a3"
    sha256               x86_64_linux:  "a55a62fecad230dfaf69feaa59a7be76ecb416897324f7a0dac1c0c0bf3aa4b4"
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

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    args = %w[-Dlua=disabled -Dyelp-build=disabled]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    cmd = "#{bin}/geeqie --version"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match version.to_s, shell_output(cmd)
  end
end
