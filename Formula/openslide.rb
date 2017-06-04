class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "http://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  revision 2

  bottle do
    cellar :any
    sha256 "39f557b8ac0ef1b909f419fea36a300cb46f567e4f894cdd897d33a136c353f4" => :sierra
    sha256 "b1491ddac157cb5ffbde3957616767a013faef8fa11028a80d79fc4632c2e2bb" => :el_capitan
    sha256 "ee965b0a44f4deab55d24bc49b2f3e1e08d9f3da95d66d067a1503b3c1ea3801" => :yosemite
    sha256 "4d822c1a8160f6b54224bb26e74fc4639bef2f27e6a9fbee824c2364c7a3bc00" => :mavericks
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
