class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3450.tar.gz"
  version "3.450"
  sha256 "bf6012dbe668ecb22c399c4b7b2814557ee282c74a7d5dc704eb17c30d9fb92e"
  revision 1

  bottle do
    cellar :any
    sha256 "bfb59c9b5b42df93624a3f4a6eca92d89ea58667b560ace653dae5a726f7fb93" => :mojave
    sha256 "9426e79aa95e40fa1f1e785738cc91df524ad040d4d25cca351ab29f7624f5fe" => :high_sierra
    sha256 "a7b46f6352f302b0302ba5c5ce5edc89d5d0d1b4b231ed87954493c721d2f9a7" => :sierra
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
