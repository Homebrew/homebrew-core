class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.92/astrometry.net-0.92.tar.gz"
  sha256 "d6eec262bb8979028d64ea05322f80eec275d7aaeed5efd537e2a79410c678a5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2795bf3051d69183e78b113cae0f28b6a9aeef3e10cfc99a55431752855d0316"
    sha256 cellar: :any,                 arm64_monterey: "4b755547bc79987424b4c1884255ce6a6c1392daa620af7e93d5383d302e6417"
    sha256 cellar: :any,                 arm64_big_sur:  "e56085d3e606485d735b1ab2bbfc0d47af9c88e5c605bac81e98b7f8f4f7689b"
    sha256 cellar: :any,                 ventura:        "417e693593c133223392d1fb56fd371b1aa2ff420f2fabd48d3fbf44c0e2299f"
    sha256 cellar: :any,                 monterey:       "1eb20742e13efb8eb4f64fff0e926033e651e3c93b69de0a88864caecda5b5a7"
    sha256 cellar: :any,                 big_sur:        "e4e096f8d3681134d7a8c08ff3e6bdeb598d95855cd27894a868d220eb7cdf0d"
    sha256 cellar: :any,                 catalina:       "f7c7c6cf9a3bb5c7b7308db32ee7400f4f925f4b78599c2e60846b663511a4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6d26f3c27a40dcbfd0ecac008cffc7ed27349f9168e7fd60261969600d2b56"
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
