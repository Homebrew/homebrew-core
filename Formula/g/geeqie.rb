class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v3.2/geeqie-3.2.tar.xz"
  sha256 "ef10cdf72d8ab739286cc26fa3ff0a3535633ceea75c4cbdea39916bf9af2e0f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "25bfd8ec1abee12514c8a9ee0c3fc21d2b5fc91331d5468ec1fb09b12f6e7d2f"
    sha256 cellar: :any, arm64_tahoe:       "f3b1f8ed75145e27a2e55f4ed9e88a801a8389c8d2d0504e23f7116f9a416ac2"
    sha256 cellar: :any, arm64_sequoia:     "36ef42c3785c249d2a2dccd54fa5e7ade98be8a725110c36d32cee88f2586bbd"
    sha256 cellar: :any, arm64_linux:       "285f462fce61db40cdc4e1b49582638e425300d31cd3b93332a1363a5055044a"
    sha256 cellar: :any, x86_64_linux:      "277f3f5632772d62a9717331c927b672821afb861cc50e185591638b32b54ce2"
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
