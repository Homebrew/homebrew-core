class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3430.tar.gz"
  mirror "https://fossies.org/linux/misc/cfitsio3430.tar.gz"
  version "3.430"
  sha256 "14905b6f91ef64a34c90ec771d21a8f6da81d8ce083680c7c41651576087cf1d"

  bottle do
    cellar :any
    sha256 "84372c9e31b2c424aa3afaab1c0cf2719582246c796833e1b90d4880612af546" => :high_sierra
    sha256 "5aff04139b4335dd316c61cd6493cb03431774ec1e782213c973a57fe7d21a0a" => :sierra
    sha256 "af24391c95ac73b8af80fb8a1963dee17cff144252285bac29f631fa5cfd43e2" => :el_capitan
  end

  option "with-reentrant", "Build with support for concurrency"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-reentrant" if build.with? "reentrant"
    system "./configure", *args
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
