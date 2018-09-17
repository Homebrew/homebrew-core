class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  revision 4

  bottle do
    cellar :any
    sha256 "e368a4e6c76204484cd7dd6f0f49e3c1ca87cef338a6c6d11561eb80d01ca057" => :mojave
    sha256 "9118b45fe096442eb436126366d3f617d8fc5e356b1a764535686115941b0aac" => :high_sierra
    sha256 "e5f7b2fe405fcbc70797c326fba07b7311b334bdd03e7ce88cfd28231557ea51" => :sierra
    sha256 "8d8bdded3aa4db040a15f1cf0c31db10832d0349320a550eaa73a0fe77abfcd6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openjpeg"

  resource "svs" do
    url "http://openslide.cs.cmu.edu/download/openslide-testdata/Aperio/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end
