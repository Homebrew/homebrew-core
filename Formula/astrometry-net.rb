class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.93/astrometry.net-0.93.tar.gz"
  sha256 "9a4854c87210422e113b8f6855912a38f0b187526171364ee2a889d36c674d70"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fcb9b79443432232792b10a4c5a47bdb50d1475fd1f1ec29f35428ae1f3ddf9b"
    sha256 cellar: :any,                 arm64_monterey: "e100c8672e261886fa944a5e07ae664c6cc125b88abc0e408b314135cd0a0644"
    sha256 cellar: :any,                 arm64_big_sur:  "1bc3fe27cbe434b0e36940984df1cc57ef664fc5b7a50932e974a19d18ac11be"
    sha256 cellar: :any,                 ventura:        "3250164d38bdca155ab140cbed0d3e1c3af9adb01d92e4c0df132c74a22ba14f"
    sha256 cellar: :any,                 monterey:       "0251706bcea94e97119486b8249b34e8ff3ec27992732919208b67730955f395"
    sha256 cellar: :any,                 big_sur:        "75654199ace88853110e1d06daa41c46f933c4798c7d8c4275fdbff9a60cb81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d70c566fcc127038285f15d9ae1602fd1321aa39e4c169a433628c1b96ab4a"
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
