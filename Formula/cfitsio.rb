class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3450.tar.gz"
  version "3.450"
  sha256 "bf6012dbe668ecb22c399c4b7b2814557ee282c74a7d5dc704eb17c30d9fb92e"

  bottle do
    cellar :any
    sha256 "ebcbb1ed7b80088ac4ea915beac08ba7978be084e34db99afd9591d7b5d2717e" => :high_sierra
    sha256 "f66bcd5b20ef607257134b5f76e7df0e98d294a6bbdd36c8c4894101e50c40c5" => :sierra
    sha256 "651c69a7f425840120233c83e6fa733d06c2214cc122880e6239559d13917185" => :el_capitan
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
