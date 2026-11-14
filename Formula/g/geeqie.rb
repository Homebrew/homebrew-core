class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v3.4/geeqie-3.4.tar.xz"
  sha256 "11da7a988ffae5c531f011d1efc10f8bb700fd26dc5bec6d175e7722ea6658cc"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "238590476bfe0a6baa3a1a0b22f6811ce9c811112e535edfb910bfe79130cc3e"
    sha256 cellar: :any, arm64_tahoe:       "17d82b27303c633784b7b48941db0271d200e8fbfc602b3f77a8a5ad05f5d071"
    sha256 cellar: :any, arm64_sequoia:     "943783dff7759d5850da33085535d8e31dca4c742f146eac28c52d67b85cab86"
    sha256 cellar: :any, arm64_linux:       "844ebc4b4c4a4b5691d6905ad36eebeb5495fcbea02812f71285484aaf4280e1"
    sha256 cellar: :any, x86_64_linux:      "44a226d3e183056797a236d8c2cf5be531618685f2278c1f59eff4b223bdda7f"
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
