class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.49.tar.gz"
  version "3.490"
  sha256 "5b65a20d5c53494ec8f638267fca4a629836b7ac8dd0ef0266834eab270ed4b3"

  livecheck do
    url :homepage
    regex(/Download the latest v?(\d+(?:\.\d+)+) version of CFITSIO/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e5e1b4c2c73622ff9302547e5bafc7e80a5b98ae2e46522efeeaab0c6531b80b"
    sha256 cellar: :any, big_sur:       "95b7f8301997e3b9c7111b8dc395b917800121a5e98edfdd0efc0f3d9adebbd9"
    sha256 cellar: :any, catalina:      "2abc3263aed574298efd50d60dd5fa07e69c5a39ed87772e3edaa727a293506a"
    sha256 cellar: :any, mojave:        "07c4d1610f3e5d90cbedb238939f588f09150edfe006f41c5072d2fb4e01980a"
    sha256 cellar: :any, high_sierra:   "ec8feab397612c13da91dd9c8e2c91289973ec1e7e10bf07f17023cf5db26745"
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
