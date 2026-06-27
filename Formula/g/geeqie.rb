class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.8/geeqie-2.8.tar.xz"
  sha256 "68bb0a56e9a84b6165e06b2309f3809677735159afc0b3f45df2937435029927"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c35062a09b9d2b4075b6f5a6ce3c52ce62ff8cda3c9aa2841684f91d052e7499"
    sha256 cellar: :any, arm64_sequoia: "0232a4c87ded56160728d151d4e145b84937fb43062d48bd5ac5c251389415a3"
    sha256 cellar: :any, arm64_sonoma:  "a473b168952332b4814ea1695087bad47282fd1ffde8d03d29174d2a3edf2154"
    sha256 cellar: :any, sonoma:        "7aff53ee3af3f5f24353e7b899e08a2310e4f8c59038d80ff8029618be2e9c8f"
    sha256               arm64_linux:   "1c281bb22959998ead44499efbd8a893ebfead5c140d5694f0d87b72521453e8"
    sha256               x86_64_linux:  "03bacb20c6587046ab2b005cfc0ad7dde0dbe26d6b5d4384fef09fbf67cca73b"
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
