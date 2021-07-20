class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.0.0.tar.gz"
  sha256 "b2a8efba0b9f86d3e1bd619f662a476ec18112b4f27cc441cc680a4e3777425e"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e5e1b4c2c73622ff9302547e5bafc7e80a5b98ae2e46522efeeaab0c6531b80b"
    sha256 cellar: :any,                 big_sur:       "95b7f8301997e3b9c7111b8dc395b917800121a5e98edfdd0efc0f3d9adebbd9"
    sha256 cellar: :any,                 catalina:      "2abc3263aed574298efd50d60dd5fa07e69c5a39ed87772e3edaa727a293506a"
    sha256 cellar: :any,                 mojave:        "07c4d1610f3e5d90cbedb238939f588f09150edfe006f41c5072d2fb4e01980a"
    sha256 cellar: :any,                 high_sierra:   "ec8feab397612c13da91dd9c8e2c91289973ec1e7e10bf07f17023cf5db26745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a4cf2b6058098fb6ed7a7f346aaa92e4cd3336d19b08c743fac516e5421bc7d"
  end

  uses_from_macos "zlib"

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
