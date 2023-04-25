class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.2.0.tar.gz"
  sha256 "eba53d1b3f6e345632bb09a7b752ec7ced3d63ec5153a848380f3880c5d61889"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69235a998168daae64fb7067937523e6951c9b2dd430dda652d75db86a596488"
    sha256 cellar: :any,                 arm64_monterey: "b267fd6580391fdced98c225b9f3a49035f59713747662992c4f940dd3d65ea5"
    sha256 cellar: :any,                 arm64_big_sur:  "17815964597e4c5d87430aa39fc74795f167722aaadcf88d344f17ebfb8c7ace"
    sha256 cellar: :any,                 ventura:        "a0148a94c73ef988e4f1853820ca3ef20b2dc276bd1dde372bf4a3d114cc52c3"
    sha256 cellar: :any,                 monterey:       "c54360549523106192e3ca5c0d342ad113a42ecd62772fa8e66d6bd4051da239"
    sha256 cellar: :any,                 big_sur:        "d8def5400ba2dd53e0e8000f650227e8ccfe320cc5b3bb476a566cf80be57bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62392eacb95d87c57dfd5b17175ee761b8577fd0ad222827ad2703bab9aff39d"
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
