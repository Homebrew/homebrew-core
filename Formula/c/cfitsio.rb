class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.4.0.tar.gz"
  sha256 "95900cf95ae760839e7cb9678a7b2fad0858d6ac12234f934bd1cb6bfc246ba9"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b03ed1452ea75406a4cb032d9ffdff6d0212fe32ed37c804dbed5131326b50b8"
    sha256 cellar: :any,                 arm64_ventura:  "eeef88260a116dfd268b0da53b5b29f68703a60d1a6d73f548c512c2bc40f8a0"
    sha256 cellar: :any,                 arm64_monterey: "9cdb23e252f43ad8297eb56127828dd3d57e925e5a697f22a572ea3246888c32"
    sha256 cellar: :any,                 sonoma:         "6fa804978d31fade2b596e6b7f8c511d7306b48521a1bfbfb99af1fb175bca26"
    sha256 cellar: :any,                 ventura:        "5dd2a84c1e4b537b80dc95cac5693fb6621407477e3dcdd2d5026d7395330b92"
    sha256 cellar: :any,                 monterey:       "15c76678e98ca4b654ebafd68915fdca5fa06641a2870bc4f2bf7995a5c7a25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06931190944abe9dd019cb2be0bf2ef97607e80e27610b1e77c550a19294df94"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "fpack"
    system "make", "funpack"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*", "utilities/testprog.c"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    system ENV.cc, "testprog.c", "-o", "testprog", "-I#{include}",
                   "-L#{lib}", "-lcfitsio"
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
