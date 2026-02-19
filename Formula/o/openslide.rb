class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v4.0.0/openslide-4.0.0.tar.xz"
  sha256 "cc227c44316abb65fb28f1c967706eb7254f91dbfab31e9ae6a48db6cf4ae562"
  license "LGPL-2.1-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1534ce31db0f8eab68925e3df74fb60fd9b3f461d6d0d99d4699496295d89d86"
    sha256 cellar: :any, arm64_sequoia: "fd6a1ef0fe67fb6d190693269e25606baf78d468d21b0c3f4e69ffb6d0f4c8db"
    sha256 cellar: :any, arm64_sonoma:  "5218d6e83f65681f182d1f8bdbe8345856e2b98b768aa75bae4ec938b961715e"
    sha256 cellar: :any, sonoma:        "929afa35741b04b99c6db1c1c3288f369de57cf068f7238e65f4c64027a67b63"
    sha256               arm64_linux:   "2efb5e0590e855d721035304d0d56a8d6b6ab3ad5763c2a8f010a11f49d584f3"
    sha256               x86_64_linux:  "7490f047fab423ba2c71a0290c87f9bb6ac2ed261b300a22b680e92d577f79f3"
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
