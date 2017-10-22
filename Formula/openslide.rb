class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "http://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  revision 3

  bottle do
    cellar :any
    sha256 "aff5345874f332ef263d00ba81c091b616577947e61cb6c5f59c1f53109985e8" => :high_sierra
    sha256 "83a0b4ad315ee19c19f5893ebd25de3d1b01e415e33321f8d207dd08467b8d64" => :sierra
    sha256 "8def2e631f2b39c2e565c43d19e747470e5edbed3eb8299815ccb0ec44149631" => :el_capitan
    sha256 "8579cea106e541c6fa69dc446e0e657dad3ddd149a5e655aefee713eb6dd0975" => :yosemite
  end
  
  head do
    url "https://github.com/openslide/openslide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libxml2"
  depends_on "libtiff"
  depends_on "glib"
  depends_on "openjpeg"
  depends_on "cairo"
  depends_on "gdk-pixbuf"

  resource "svs" do
    url "http://openslide.cs.cmu.edu/download/openslide-testdata/Aperio/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end


  def install
    if build.head?
      system "autoreconf", "-i"
      system "./configure", "--without-makeinfo",
                            "--disable-static",
                            "--prefix=#{prefix}"
    else
      system "./configure", "--disable-dependency-tracking",
                            "--disable-static",
                            "--prefix=#{prefix}"
    end
    system "make", "install"
  end

  test do
    resource("svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end
