class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.7/geeqie-2.7.tar.xz"
  sha256 "9b5f342d3cc47782716711e56c3c7a045b4bbeaa653e192d49ce2d5e87ac8106"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "09fbec3d3b21662016a7482e167aad3fa692ddb3aeed083ca40583558d00dd63"
    sha256 cellar: :any, arm64_sequoia: "18c9ccdc9b1fe413a804383a6a123d2355fde97fdd4a431549844d17ef5ab1c7"
    sha256 cellar: :any, arm64_sonoma:  "f45f38aa132c356c2671a5e04cca80e8e4b49e2fd9ca6ad0fff96129a03087a6"
    sha256 cellar: :any, sonoma:        "e1875d09c170c48286076cf07a4af96812b13fb24d68ea7619982ee19baaf050"
    sha256               arm64_linux:   "d9557e4598827db671ea782ab1da9167c7bbdec229a452770f5347e9b4b0d4bf"
    sha256               x86_64_linux:  "bafe6e63172cb0be136ca68aa7a57574daca5a777e7c9a5ecfeb3c658f713b98"
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
