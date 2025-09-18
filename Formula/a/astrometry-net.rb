class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.97/astrometry.net-0.97.tar.gz"
  sha256 "e4eef1b658ba5ad462282b661c0ca3a5c538ba1716e853f7970b7b9fa4a33459"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "40d9adfbe503f17ae412e6e357b184cb452866a792028a6ba742bd2d7022d26d"
    sha256 cellar: :any,                 arm64_sequoia: "fb1c46f5984a4729f163e70038d0057364ba035833bfd43a0ed69c7b58ffb04e"
    sha256 cellar: :any,                 arm64_sonoma:  "8d8cd0c7df299f886f2cafdcc5930560bb5cdcba9a8241cbe11c2e882e1ad245"
    sha256 cellar: :any,                 sonoma:        "5fe145bb419c5c4179900ec62969cda35c80fad2d34a78a2e9dfde8419eb7f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "309d750564e789b98b1da8bdb2c83b5fc57ee87a9f7e6915dfcbcd42e74a0313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e9e3724461fa8339b641411a665f30bc2879fbb1ac66da6e8bdc5e5753864a3"
  end

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://github.com/esheldon/fitsio/archive/refs/tags/1.2.7.tar.gz"
    sha256 "356a425ce1c5c64e42685e1196f1d5fb43ec8fefb7f800232f756360e1a2a38a"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    ENV["FITSIO_USE_SYSTEM_FITSIO"] = "1"
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python3 = which("python3.13")

    venv = virtualenv_create(libexec, python3)
    venv.pip_install(resources, build_isolation: false)

    ENV["INSTALL_DIR"] = prefix
    ENV["PY_BASE_INSTALL_DIR"] = venv.site_packages/"astrometry"
    ENV["PY_BASE_LINK_DIR"] = venv.site_packages/"astrometry"
    ENV["PYTHON_SCRIPT"] = venv.root/"bin/python"

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
    assert_path_exists testpath/"jpg/apod4.solved"
    assert_path_exists testpath/"jpg/apod4.wcs"
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.xyls",
                              "--continue", "--dir", "xyls"
    assert_path_exists testpath/"xyls/apod4.solved"
    assert_path_exists testpath/"xyls/apod4.wcs"
  end
end
