class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.94/astrometry.net-0.94.tar.gz"
  sha256 "38c0d04171ecae42033ce5c9cd0757d8c5fc1418f2004d85e858f29aee383c5f"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e1dd4ca98634847a4cca6c0898e1e0785be7a460b8a91a1ba923eb8e4f54193"
    sha256 cellar: :any,                 arm64_monterey: "f1fe0247102eca1ceee3d7a6ea1ac3c54e500946ebfe52254f7e1a51477002f3"
    sha256 cellar: :any,                 arm64_big_sur:  "74130a63e3eb338b5b77ef505b216f4bcd7a7d421cf3e40c96b038e3c7ffcd65"
    sha256 cellar: :any,                 ventura:        "42b242fc7dc1c5c9a60b4ca1ce5368db5b92700f8d233cf848a2aa34d09098f6"
    sha256 cellar: :any,                 monterey:       "eafeaf9929cbce8b0a6fb8cd3efe312e3c203285466ed747dd669c3fd7d8c2e1"
    sha256 cellar: :any,                 big_sur:        "14847578626078f3c588cf231977d34f4ccebd195e4424a8c5516d374b2b4de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd984b5e0e8aaa946a22648142f75f8b61c1c511d044946c00bd8867d8178e7f"
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

  # https://github.com/Homebrew/homebrew-core/issues/130484
  # Review for removal on next release
  patch do
    url "https://github.com/dstndstn/astrometry.net/commit/f85136190b6e39393049e9be1cf14ac32b89b538.patch?full_index=1"
    sha256 "82f8968805dacfd66961ea7cfea7e190be6faaaaa5367f2b86b0b5a62f160706"
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
                              "--continue", "--dir", "jpg"
    assert_predicate testpath/"jpg/apod4.solved", :exist?
    assert_predicate testpath/"jpg/apod4.wcs", :exist?
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.xyls",
                              "--continue", "--dir", "xyls"
    assert_predicate testpath/"xyls/apod4.solved", :exist?
    assert_predicate testpath/"xyls/apod4.wcs", :exist?
  end
end
