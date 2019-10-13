class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.47.tar.gz"
  version "3.470"
  sha256 "418516f10ee1e0f1b520926eeca6b77ce639bed88804c7c545e74f26b3edf4ef"

  bottle do
    cellar :any
    sha256 "8526e82f6e3d21a8dbe6192b08d703fed77c82bf3a88e9a3e62439b9f7c0d3bf" => :catalina
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
