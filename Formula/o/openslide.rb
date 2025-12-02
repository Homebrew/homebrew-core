class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v4.0.0/openslide-4.0.0.tar.xz"
  sha256 "cc227c44316abb65fb28f1c967706eb7254f91dbfab31e9ae6a48db6cf4ae562"
  license "LGPL-2.1-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6732044b22142a2bd2720461df199de641a51534e55fa730c043e284f7e11fa"
    sha256 cellar: :any, arm64_sequoia: "5674f43c8c5f3495a223de96360ec92306bef079d897c6ac2b4d4634f1ce27fb"
    sha256 cellar: :any, arm64_sonoma:  "f90a97a6b1861db3924b62c79c38d07ce6c67e3c181d6be05f50151358db269a"
    sha256 cellar: :any, sonoma:        "b6394094dcbaf4b34605e30db09d1ac4a9446d092f9a8bc2e85de05b5eccde1c"
    sha256               arm64_linux:   "27b0aa609f33715e0e4e7a404cdcf44086401e1604696701c3f9f5a7f6aa250b"
    sha256               x86_64_linux:  "d8c2c8c3e74e9d463df6d5a68ba5a8a69e6e4558de237e039de88fd8f5bffb10"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
