class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  license "LGPL-2.1-only"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2998607f92e8f01e4345d91de86c543c1e497f8299081375df950424757440fe"
    sha256 cellar: :any,                 arm64_big_sur:  "3b88ac6e608998bd2827df643d3d31e7ccfd378897c00bf49cd288bccc323135"
    sha256 cellar: :any,                 monterey:       "5859fd88a2ff452ef1aa5301b92470f0635c186b9432582b1ba2851319ef4395"
    sha256 cellar: :any,                 big_sur:        "deff242ac11d416afaf96f7605421bf1d6e8d98d5217410a72882865fe730355"
    sha256 cellar: :any,                 catalina:       "14888109869095cf759e9d6b0fb8cd71d848914d9b04303bc3fdc3bd210d09d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c5af6047de15305377bf4248f12e76f6d0adf5cec532bbb0a183c3ee1fe56dd"
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

  resource "svs" do
    url "https://openslide.cs.cmu.edu/download/openslide-testdata/Aperio/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource("svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end
