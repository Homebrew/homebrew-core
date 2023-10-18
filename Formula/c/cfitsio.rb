class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.3.0.tar.gz"
  sha256 "fdadc01d09cf9f54253802c5ec87eb10de51ce4130411415ae88c30940621b8b"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66bbe65d87983f36e5c6ca2d99298648d40cd8c230f34cd0ef7a77752eae895d"
    sha256 cellar: :any,                 arm64_ventura:  "2277a6e4c476abc34b523cf109c953b3806e64c2d1cb9b84da1ab7b9ceeeef5f"
    sha256 cellar: :any,                 arm64_monterey: "add3210ab372315981d5d605e4ffff89fa86b084de194d0e23f74a3cd4d0ddc6"
    sha256 cellar: :any,                 arm64_big_sur:  "5dbf782fda9673167313fc383297801f5fcacf28c5b77d7890d1e14c31de1971"
    sha256 cellar: :any,                 sonoma:         "1ba1c40e953cdd9259d42bf17e8590b20d929c2d8df4d0446f6130ce7a9551ed"
    sha256 cellar: :any,                 ventura:        "bc600b6381d62b0dd5eb710be4e355655f4e70484e9a35e1e649a1b0a01e191e"
    sha256 cellar: :any,                 monterey:       "e003577a5564d577f30d283aba0aacd7ee5a3bd61381de6f511ec48d7c7349f5"
    sha256 cellar: :any,                 big_sur:        "0eb99bd2ea626eef4ad8ea6966b4591ae6f13e4a41be6586d1397838fdcc73f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a2da00592ef8a3f786b2ad112f89d35c3b85d09ba5cfc2491066fd286812ef"
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
