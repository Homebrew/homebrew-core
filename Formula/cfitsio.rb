class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.48.tar.gz"
  version "3.480"
  sha256 "91b48ffef544eb8ea3908543052331072c99bf09ceb139cb3c6977fc3e47aac1"

  bottle do
    cellar :any
    sha256 "efaeebd4d115eabfc622672dc88f12b4aafce9ff20bce08e887147985c42d781" => :catalina
    sha256 "a35caaadc929ff314d3b93b9bd8951b263724ef8300a433fe7607a477ab2b1d7" => :mojave
    sha256 "27d890a098774743dd8c60c77d9faa7e303f52dfc977ebaa54469ff393c84929" => :high_sierra
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
