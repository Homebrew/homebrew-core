class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.20.2.tar.gz"
  sha256 "dc1b486c2003435733043e4e05273477326e51c3ea554c6864a4eafaff1004a6"
  license any_of: ["LGPL-2.1-only", "CDDL-1.0"]
  revision 1

  livecheck do
    url "https://www.libraw.org/download/"
    regex(/href=.*?LibRaw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9602e190b1f8832e73e1051483ce19d6bd70b5e62de19a3ef111fdbd00808554"
    sha256 cellar: :any,                 arm64_big_sur:  "23249a1e63273e0d9b5af9ee3cedd67bcb6e5f8ab732c373e564e6f78cc7c247"
    sha256 cellar: :any,                 monterey:       "10810b4d3f4bd93770c831d32c2feb7e65d3fb8150c33a559f9cda90d12a3b92"
    sha256 cellar: :any,                 big_sur:        "aa06e46a54ce57dc4be77bb8ad8b65275938a2b2b18184258e990a22fc242f7c"
    sha256 cellar: :any,                 catalina:       "da61cecad94bd946f622d18440360ba02751dde1ceeea072f930e41dacfcde59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c038b9e4c35a477afb9ed9fd5834d622a43288c88e8375684c358e45a87013"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
                          "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
                          "LDFLAGS=-lomp"
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
