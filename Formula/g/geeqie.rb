class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.9/geeqie-2.9.tar.xz"
  sha256 "5f0214778112da6daf3736a6ea04c10b093ea339dcc54676435a097ef8dfcd2d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e92fa4ff7724bd6cb9f47ba0af534fe1d74614bbc02a7b619e9489123b6dc476"
    sha256 cellar: :any, arm64_sequoia: "333b5e609e7bcf290e2cc3099c2bb2e8b476ff8154f0c81927575cb532354864"
    sha256 cellar: :any, arm64_sonoma:  "3e5aec9764ab0e277b5f074bb8175681dc82ffac2d83d2b8cf18b3d4d27f7e0a"
    sha256 cellar: :any, sonoma:        "c82e739cd06d90f13dadd8ca0609e4a32a97135a8e3b84b71e918d6f12583f91"
    sha256               arm64_linux:   "2da432a7381fe2e5529ab131b2986fc1d3b5f58644d3daf2596a43169dcda4f4"
    sha256               x86_64_linux:  "684043be826b719fced8715bd71642b5154710a73326952d081e34b20a63d4cf"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "exiv2"
  depends_on "ffmpegthumbnailer"
  depends_on "gdk-pixbuf"
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
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "poppler" # for pdf support # for video thumbnails support
  depends_on "webp" # for webp support

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "vim" => :build # for xxd

  on_macos do
    depends_on "gettext"
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
    # Geeqie 2.7 currently crashes in Linux CI when initializing the GUI stack.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    cmd = "#{bin}/geeqie --version"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match version.to_s, shell_output(cmd)
  end
end
