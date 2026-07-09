class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v4.0.1/openslide-4.0.1.tar.xz"
  sha256 "df82f6b264f98d11eeb80d85bbb10c7935fcd69c7abae1d610ce49b9a0437faf"
  license "LGPL-2.1-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7cf048eea4e3bba759ecee695c16dc06f5a0f477a7190ce69f0e750ff0e891d2"
    sha256 cellar: :any, arm64_sequoia: "5e0356dda9487bdfe10b972bee283fb9d1782a2ae54c5f236480d0a8079ec4cf"
    sha256 cellar: :any, arm64_sonoma:  "f4985abacc0fb2b99181346b7f49577408f0a06a571dc7c59de52bf5cb151fc6"
    sha256 cellar: :any, sonoma:        "cc2bf4262eb1da4400faa1e2173aef99d87af8527d84547e0ffdaec1db001a14"
    sha256               arm64_linux:   "428a3d9e8721f0ac29021f3ac77c9184c2762baff69d2c64d327fa99fb309607"
    sha256               x86_64_linux:  "ccaaaedae76fbb10acea27da04acde8a2a1583f781ee8f137942a974de4cced3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libdicom"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openjpeg"
  depends_on "sqlite"
  depends_on "zstd"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-svs" do
      url "https://github.com/libvips/libvips/raw/d510807e/test/test-suite/images/CMU-1-Small-Region.svs"
      sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
    end

    resource("homebrew-svs").stage do
      system bin/"slidetool", "prop", "list", "CMU-1-Small-Region.svs"
    end
  end
end
