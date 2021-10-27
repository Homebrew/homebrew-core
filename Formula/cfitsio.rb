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
    sha256 cellar: :any,                 arm64_monterey: "afea431a19d9ca7ba8647813f18484fbc29d7f74ab31c5c3090e6c28e5e31b7a"
    sha256 cellar: :any,                 arm64_big_sur:  "663a708c8bc435958830dd4b3e703980a25892712098a53aa1e6cbd812cfecd1"
    sha256 cellar: :any,                 monterey:       "d02bd49fa97a23ac9b53cef9f49d9eba6545b67455aa98e8f9867126ca6c4d14"
    sha256 cellar: :any,                 big_sur:        "bfc9fd29dd3909123ab1ee9d1c0fa36543bfc4a330690826b8a94c545544888c"
    sha256 cellar: :any,                 catalina:       "63e9df9a5660a778941cc264639547715cd2f264cba7c57731ffe399c2586ec1"
    sha256 cellar: :any,                 mojave:         "d98bbd662f25cc6d961a8ba28c3c743474e0c05aaa8ea83b710c9469669de424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c0e76dd62d49e3aa80004128ac6eb9c8f84cc3139efe3d07eed740b17a31ebe"
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
