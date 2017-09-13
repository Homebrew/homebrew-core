class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3410.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3410.tar.gz"
  version "3.410"
  sha256 "a556ac7ea1965545dcb4d41cfef8e4915eeb8c0faa1b52f7ff70870f8bb5734c"

  bottle do
    cellar :any
    sha256 "a72624afaa8ea443c369bb0488fc1c9777c0eb69406366abe5fb8baa9535cc1c" => :sierra
    sha256 "3fed2108f06719ca7661466ae8cdaf9a8a1c36fd45e44472377e66ff483b62f6" => :el_capitan
    sha256 "113ce9d721d80abc9d09aa5e4e947ee62a618c16e47510a3c2e58ae97211d5ac" => :yosemite
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
