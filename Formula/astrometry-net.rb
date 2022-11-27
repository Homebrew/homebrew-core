class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.92/astrometry.net-0.92.tar.gz"
  sha256 "d6eec262bb8979028d64ea05322f80eec275d7aaeed5efd537e2a79410c678a5"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c084a215df96193428b5be2c4e9bf63377692d5312834981c19a24a83c3825ce"
    sha256 cellar: :any,                 arm64_monterey: "b938a76bf2321eb975bfcf90ad94e5ca256f0f2b71c3259dc486b1f0dd729a7a"
    sha256 cellar: :any,                 arm64_big_sur:  "76c407270dfa0aa73910e98c49b5c69209092d35306efda91a25ef85823255b3"
    sha256 cellar: :any,                 ventura:        "f13c5f2f13dc4ad5812bafb969eedbbd0c95dbee8874994fd385104c59b25449"
    sha256 cellar: :any,                 monterey:       "f7fe5bdcc8207f971de1689f4b1abb49a3753c5eb82ed242cb976c2ecceff98e"
    sha256 cellar: :any,                 big_sur:        "13da4e8722df5de2582a008a489c559131116d343481ee2a2c8372932152e696"
    sha256 cellar: :any,                 catalina:       "b9d61e42e7674021e031380a174f9e66ebcd541ae85c089760888ecb1151e7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96dc3f32a449fa1d8eff381afcb83f7a9f6bad4b651c92809399c7da60255102"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/1f/0e/b312ff3f6b588c13fc2256a5df4c4d63c527a07e176012d0593136af53ee/fitsio-1.1.8.tar.gz"
    sha256 "61f569b2682a0cadce52c9653f0c9b81f951d000522cef645ce1cb49f78300f9"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    python = which("python3.11")
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python

    venv = virtualenv_create(libexec, python)
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    site_packages = Language::Python.site_packages(python)
    ENV["PY_BASE_INSTALL_DIR"] = libexec/site_packages/"astrometry"
    ENV["PY_BASE_LINK_DIR"] = libexec/site_packages/"astrometry"
    ENV["PYTHON_SCRIPT"] = libexec/"bin/python"

    system "make"
    system "make", "py"
    system "make", "install"

    rm prefix/"doc/report.txt"
  end

  test do
    system bin/"image2pnm", "-h"
    system bin/"build-astrometry-index", "-d", "3", "-o", "index-9918.fits",
                                            "-P", "18", "-S", "mag", "-B", "0.1",
                                            "-s", "0", "-r", "1", "-I", "9918", "-M",
                                            "-i", prefix/"examples/tycho2-mag6.fits"
    (testpath/"99.cfg").write <<~EOS
      add_path .
      inparallel
      index index-9918.fits
    EOS
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.jpg",
                              "--continue", "--dir", "."
    assert_predicate testpath/"apod4.solved", :exist?
    assert_predicate testpath/"apod4.wcs", :exist?
  end
end
