class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.3/geeqie-2.3.tar.xz"
  sha256 "cd5cad97f8d0e8c62025334d62688fcf6f82be73a7716c5ca16b205d59b8519b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "00e12bb86816fbb76c4ae7291f2721467765834a688feabdf4c3981e26e49f46"
    sha256 cellar: :any, arm64_ventura:  "0edc216cedcd6d1a28490e1959ae27e06ae72ee9375230d3c4c7c79b675c6f0e"
    sha256 cellar: :any, arm64_monterey: "a223a3d09e500e22b43ab19f4666cd5dc1679b8c92be94d81b3d02c864762a28"
    sha256 cellar: :any, sonoma:         "99ef67d5e6e67203005f3fd87f5f43f464c0a1aacb55d4e27b3d94c756a0dd33"
    sha256 cellar: :any, ventura:        "c0975ef8d5efeb67dba0a8dc446add42b41e57e94a8cbe7b48c205b8cd9d15b9"
    sha256 cellar: :any, monterey:       "fe514a965f56343e745d6e64ebc5be8b77d83bbd21fc439a4842d23f95f823e3"
    sha256               x86_64_linux:   "ab15173508e65f6d607f5b106446a292967bef34c5d0401c38feeb6a7ce52d50"
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

  # macos build patch
  patch do
    url "https://github.com/BestImageViewer/geeqie/commit/4a9376a78d258ff11e9db33985abbfb9a7be614c.patch?full_index=1"
    sha256 "f9c49cec18cbeb9e764e7ed51cdbeec005f5dbcf99efc26f7e254bb32be1acc9"
  end

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
