class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.7/geeqie-2.7.tar.xz"
  sha256 "9b5f342d3cc47782716711e56c3c7a045b4bbeaa653e192d49ce2d5e87ac8106"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3fd0f03b1df26f2e61b742079f7f664a5918cf7044e09bd98d2f6693af73816"
    sha256 cellar: :any, arm64_sequoia: "270e21e0c75d58912368404c6bf0046a9dd63ac1563b313ce5e7463be6e9658b"
    sha256 cellar: :any, arm64_sonoma:  "c5d85e87b206e402c9f0071bfb144b4f9004d91496280b311dd8f8c777f8060a"
    sha256 cellar: :any, sonoma:        "a26edfc97367bd2628218bfac629b31d72fee788236b9bab6b76f79a38a81472"
    sha256               arm64_linux:   "c7f84e3cbe65148e8d8e0436a1cea684ac80958aba99b211500d5d80b1a4c427"
    sha256               x86_64_linux:  "dc92b1f6a42205906725f03bee3a7ef0f1fdd2637bac9d8e45a5d8bca4f12d42"
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
