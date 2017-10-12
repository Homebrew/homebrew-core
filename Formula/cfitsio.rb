class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3420.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3420.tar.gz"
  version "3.420"
  sha256 "6c10aa636118fa12d9a5e2e66f22c6436fb358da2af6dbf7e133c142e2ac16b8"

  bottle do
    cellar :any
    sha256 "8b21e0a610d1caa8d8900546d2b2d9f83f74a9f1bd0d3e729f1ab1ad28b81813" => :high_sierra
    sha256 "b2f55b8504d79e27d23b5fa93f77ff9bc2488eef4f5ed94c7a16757505df4462" => :sierra
    sha256 "7681f60baee8d9a73639be3f54d7f4a1c71c9fc9f4ac7fd0e3ba20cb2a2c3c7b" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
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
