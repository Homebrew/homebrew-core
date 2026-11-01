class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v3.4/geeqie-3.4.tar.xz"
  sha256 "11da7a988ffae5c531f011d1efc10f8bb700fd26dc5bec6d175e7722ea6658cc"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fd1c44d2c206d179f87798ff021de864bebf9c622ecb8bb455c33df8f273fc66"
    sha256 cellar: :any, arm64_tahoe:       "0f1013e60266b126e11aa1234bb6c573e57c05cd21a778ced65df88f690cf23f"
    sha256 cellar: :any, arm64_sequoia:     "f2cd519aba6669d573163d29685258648c1cb6140e638fdf830749f68a78b331"
    sha256 cellar: :any, arm64_linux:       "21ccddb95176abc9374dc39cedd7968ca57d00699a348eda2041d46155b936fb"
    sha256 cellar: :any, x86_64_linux:      "8bfc05defda648c757442d76d48780d8ed1d0ceb608847a17ad22fb80bac66c5"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "exiv2"
  depends_on "ffmpeg"
  depends_on "ffmpegthumbnailer"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gspell" # for spell checks support
  depends_on "gtk4"
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

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib" if OS.linux?
    args = %w[-Dlua=disabled]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Geeqie 2.7 currently crashes in Linux CI when initializing the GUI stack.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    cmd = "#{bin}/geeqie --version"
    cmd = "#{formula_opt_bin("xorg-server")}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match version.to_s, shell_output(cmd)
  end
end
