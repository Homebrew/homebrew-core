class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  license "LGPL-2.1-only"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "afb277f95420c92e38e2735224127bfe63bbca01549c3ad63b2b1d110f85df3b"
    sha256 cellar: :any,                 arm64_ventura:  "e583738663abd681d8251f1dc228f025c1c6938a928a96b728bce74fa34353c0"
    sha256 cellar: :any,                 arm64_monterey: "d37da9b5759f55d1d70a911a237c9be6275b3dc645c393cbd0467799fa17e989"
    sha256 cellar: :any,                 arm64_big_sur:  "b2368526acf0b7b6ea124c2c9b5faa93aff6f6e933ff7f53c8db6499094d2782"
    sha256 cellar: :any,                 sonoma:         "4f3fa6514f9f6449b0a23962cbef7c89c1801efe93d5c4e28cd40d23519985ed"
    sha256 cellar: :any,                 ventura:        "196c77d171091b1ebdd7c8697c3241fa8102b0965fb2bee4f03118ed139061eb"
    sha256 cellar: :any,                 monterey:       "33e28390bea7296e1eac8f5e70c4099d53c90191138690382933350615ece546"
    sha256 cellar: :any,                 big_sur:        "f62cbddfc327ae795bdceed9c3c66dc22e955a28cd14190ae6844f990c346301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34556c96b3b25692de68c4a7896f59ff5ce4a2d8940844e64b6ab6674fb6e40d"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openjpeg"

  uses_from_macos "sqlite"

  resource "homebrew-svs" do
    url "https://github.com/libvips/libvips/raw/d510807e/test/test-suite/images/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource("homebrew-svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end
