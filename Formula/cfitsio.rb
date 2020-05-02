class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.48.tar.gz"
  version "3.480"
  sha256 "91b48ffef544eb8ea3908543052331072c99bf09ceb139cb3c6977fc3e47aac1"

  bottle do
    cellar :any
    sha256 "60f903aaeaa52557c810add80ab3771f8ac4b29e8839c6463ad94d7f412f367e" => :catalina
    sha256 "8b726717e06bde963e9935a5e8d3abaf8e77107afdeff90e2550997dc689b7c7" => :mojave
    sha256 "ae27f5c7b1886a7380c043f2df0c9ed02af35802c901dc0c8d6b4f6f710afddd" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*"]
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
