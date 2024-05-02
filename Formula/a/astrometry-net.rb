class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.94/astrometry.net-0.94.tar.gz"
  sha256 "38c0d04171ecae42033ce5c9cd0757d8c5fc1418f2004d85e858f29aee383c5f"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "74ed6b8e8114f32c5d29b8e2eb84c87e5d5ceafaca6a21fe6b8ee5404b0f6223"
    sha256 cellar: :any,                 arm64_ventura:  "b8f2403b1165e7723111bafd6b697ae4e1ee504503d8cc916d35742ade4af6e1"
    sha256 cellar: :any,                 arm64_monterey: "c2b14e52434a8767a5268034ea76ee03b7745b0b96896fc11ca3aab58628c55c"
    sha256 cellar: :any,                 sonoma:         "8710c8d9c37acc8d307ca2edc358a45aa12c76075a27cce6b3e95e7481fbb5b8"
    sha256 cellar: :any,                 ventura:        "33255a455c88e5ae8ee6b7fe6386db0768a309e287ca5ab515845b446aa6fbc4"
    sha256 cellar: :any,                 monterey:       "ed7ca096dbfb927e8800395c0799313c42411014c25f321404c9ae6dfc97af35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe73a8422de550c2700a5a14053e845cfaa7af91847840c3ae9664a07cf5220"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/aa/03/d7d0b77f938627cb46f6d91257d859c78459fbb5b155899d6c4c78970faa/fitsio-1.2.1.tar.gz"
    sha256 "c64f60588f25fb2ba499854082bca73b0eda43b32ed6091f09dfcbcb72a911a6"
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

    python = which("python3.12")
    ENV["FITSIO_USE_SYSTEM_FITSIO"] = "1"
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python

    venv = virtualenv_create(libexec, python)
    venv.pip_install(resources, build_isolation: false)

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
