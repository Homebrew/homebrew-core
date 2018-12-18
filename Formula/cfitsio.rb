class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3450.tar.gz"
  version "3.450"
  sha256 "bf6012dbe668ecb22c399c4b7b2814557ee282c74a7d5dc704eb17c30d9fb92e"
  revision 1

  bottle do
    cellar :any
    sha256 "d2f30916f14efa1e721e39374778cae8dd7b3e7a032846657816036c022aad12" => :mojave
    sha256 "a74d1db66c52504a7b9e0f72f06ea8c2a96eb988b9882473139447a2db865830" => :high_sierra
    sha256 "e916758becbd9c480f685c44343d99f2d0d01329bf1687f4f2b711dc51782612" => :sierra
    sha256 "f5e9a01028f38a17ddd05488dd261eb235c34512b0ef6bade5c875525644ea54" => :el_capitan
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
