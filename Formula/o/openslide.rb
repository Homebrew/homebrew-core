class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v4.0.0/openslide-4.0.0.tar.xz"
  sha256 "cc227c44316abb65fb28f1c967706eb7254f91dbfab31e9ae6a48db6cf4ae562"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "cc59b3af87286b37130ec9a898f182814aa291268a9e2548e5525e765f4996df"
    sha256 cellar: :any, arm64_sonoma:   "5bdd7e9c3409e9a540d861b0cb58ff7e94b51f38ec1c04d2b07dbf8d69d01933"
    sha256 cellar: :any, arm64_ventura:  "389ba9d6f9bb8e28d960277976ba1159083ded06ca6b6d01cbbdb5688296579b"
    sha256 cellar: :any, arm64_monterey: "413e235cb5da773c304affa0719c5b8d1e0031d0f17fbc4263ad411d4c97b784"
    sha256 cellar: :any, sonoma:         "24268fa9a0759d1ee9997ca8b4f34d8fbd24ad5f0b5b5cbdbf7a4eea8f447324"
    sha256 cellar: :any, ventura:        "954bbde8c99630dd94c6486021674eed997475307f248d4957767e4a018b0739"
    sha256 cellar: :any, monterey:       "05788d5b3c3101ce73c9080c0d0c360d151cf2460a68b7dfe0bd3effb2c20460"
    sha256               x86_64_linux:   "d67053c017a5e1e57189a2d774cac9d8bbe2c655240183ce65247a0a8650c917"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libdicom"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openjpeg"
  depends_on "sqlite"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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
