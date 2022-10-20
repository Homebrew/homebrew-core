class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.91/astrometry.net-0.91.tar.gz"
  sha256 "832b7613a2a2974be0fb85b055b395707d10c172846e5cf83573a4e759a83b8e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a21c4d8c622dd250ce4088b8cca7c947a10f5b4c2b1504ce2ffd95122d18ee38"
    sha256 cellar: :any,                 arm64_big_sur:  "2f05f2250be4b8fb352db9b4913c626e9c2ca2e29290255b4b41696b1a645620"
    sha256 cellar: :any,                 monterey:       "1664b3417832a7d24f6115876067e826655e7eb5cf27b59de2a927a310d65742"
    sha256 cellar: :any,                 big_sur:        "4908975f094a8fb427b1c06106e5dd438588ff10265e321fd3a9f3af5a95146c"
    sha256 cellar: :any,                 catalina:       "2cba5b3900b126f07cdcae5eea18103d45b2734a5f848d220214f5f0f46eda2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccad9926b55e6183c384a3523ee8375496be3493b48372d9cd56bcc6bee444c6"
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
  depends_on "python@3.10"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/23/ec/280f91842d5aeaa1a95dc1d86d64d3fe57a5a37a98bb39b73a963f5dc91d/fitsio-1.1.6.tar.gz"
    sha256 "3e7e5d4fc025d8b6328ae330e72628b92784d4c2bb2f1f0caeb75e730b2f91a5"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    python = Formula["python@3.10"].opt_bin/"python3.10"
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
