class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.2.0.tar.gz"
  sha256 "eba53d1b3f6e345632bb09a7b752ec7ced3d63ec5153a848380f3880c5d61889"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bb88a06bf9a7699e3dc69e5143fde488ae117f3803337f81c095106b68e18215"
    sha256 cellar: :any,                 arm64_monterey: "0269cf18a5dd1ce217c799461fb5831db284edb3d05c2b144ce30a7a1566f246"
    sha256 cellar: :any,                 arm64_big_sur:  "f95d18fe4f060505e6695bef0cf5ea228493b872e71052c68aa4d03c8378804e"
    sha256 cellar: :any,                 ventura:        "d0f59412836cd94a60ed15ec1b84940c9bea99a8d35d2198e54e1ecab5377141"
    sha256 cellar: :any,                 monterey:       "62cf2942b05394dc7b906aba1fc6b2b27c24caf81fc85263d1697ed488fc230a"
    sha256 cellar: :any,                 big_sur:        "708ad462a892a776bcc62a1e5c8627f6de9fa7bb83f9a107daffa0d099968837"
    sha256 cellar: :any,                 catalina:       "7206c141ca07704be2485f297eaa44f6d6ed62edaeab41efe6356c78da10ddc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea728776b33a24f236b21ecedfc7430fee6bb4c551e94e772785b38994b93b99"
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
