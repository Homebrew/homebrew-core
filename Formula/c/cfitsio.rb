class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.5.0.tar.gz"
  sha256 "e4854fc3365c1462e493aa586bfaa2f3d0bb8c20b75a524955db64c27427ce09"
  license "CFITSIO"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6139f7d1a4dfe717577e7226a84a1dd5d8d42040cc0a7c8354a75256b2b10d4"
    sha256 cellar: :any,                 arm64_sonoma:  "1e7e4fda58375d9d078b921619e56faf26bd292929efe86d92b71eb87ff1d0b8"
    sha256 cellar: :any,                 arm64_ventura: "d35c85a73544d6203d2b3f56ca42442df061a0a6e51c9a4afe3f98ca2d9345aa"
    sha256 cellar: :any,                 sonoma:        "bd4d8e9a2605a35c33e104e61a9e698779b24436dcc034c71971b4710a6f9ddc"
    sha256 cellar: :any,                 ventura:       "89f00358a0b2e72c71145d284ad6a87e9a83ad21bac6dafdf1030b486421f579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c62d02305a42040e5955fa82615f4b7be982d511cc166fbc85a0febbead1be5"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  # Fix pkg-config file location, should be removed on next release
  patch do
    url "https://github.com/HEASARC/cfitsio/commit/d2828ae5af42056bb4fde397f3205479d01a4cf1.patch?full_index=1"
    sha256 "690d0bde53fc276f53b9a3f5d678ca1d03280fae7cfa84e7b59b87304fcdcb46"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"testprog").install Dir["testprog*", "utilities/testprog.c"]
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
