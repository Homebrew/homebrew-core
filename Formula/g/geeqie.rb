class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v3.1/geeqie-3.1.tar.xz"
  sha256 "ca550826e30fee9d6ccfc621ddd0e4c430d440f51cdfcbebe623cedfe64fd805"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ac7a7e716b5c1f253ac8ce8c1329fe69e6eca7fba4acc69d515afc135e70c1b"
    sha256 cellar: :any, arm64_sequoia: "aa1092c0b0859252bd374eaccfa40f6bea4341dcf56f287fd631bb62b3a296e3"
    sha256 cellar: :any, arm64_sonoma:  "a563501590477fbc2565b62da57f005b9025519954e48c9a1c1019a90b6ddd08"
    sha256 cellar: :any, sonoma:        "f7942ef6f84f8c7e401306647d926a093f888a4e04ac71d666ddd96edfa25e8f"
    sha256               arm64_linux:   "db14107c08e880841f29222f9864666461cc6c3b7f35fcf74575061f3db54954"
    sha256               x86_64_linux:  "fb44ac9dcf9764a5fa85a234176118e9c5bd60bff3ae37ddfbe4770c78d58f66"
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
