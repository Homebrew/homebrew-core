class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.96/astrometry.net-0.96.tar.gz"
  sha256 "fb3f2ec09cbe155d9ff461b9a60336f8493f5cb7804199e1782664e9034c9aac"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "f1bbde0a339c8945bd6dfafa9bd600e0f64f4ac436e1b24b1e1ea29d69a0cbec"
    sha256 cellar: :any,                 arm64_sonoma:  "28a9cf7512a67a5254942e999848970fc37fc260f24be235cdb00bd5cc73ea67"
    sha256 cellar: :any,                 arm64_ventura: "4a3bbbaaf304a430652453c98238d3af806edf368aff66253d221705b9175848"
    sha256 cellar: :any,                 sonoma:        "b4cb1d75bb7ed5de5d080760db6b0a81dac3798a6d5439be01f1d423ad6c1c0d"
    sha256 cellar: :any,                 ventura:       "c4780f3e9aaf73c835cfc421aa927d52e33c30837911776e34e068d49c94ce12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feab592ac829d2863bf2ce65d50d9c880cfa60b513f6ac0a6d70dfe8aa13c1e3"
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
  depends_on "python@3.13"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/6a/94/edcf29d321985d565f8365e3349aa2283431d45913b909d69d648645f931/fitsio-1.2.4.tar.gz"
    sha256 "d57fe347c7657dc1f78c7969a55ecb4fddb717ae1c66d9d22046c171203ff678"
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
    assert_predicate testpath/"jpg/apod4.solved", :exist?
    assert_predicate testpath/"jpg/apod4.wcs", :exist?
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.xyls",
                              "--continue", "--dir", "xyls"
    assert_predicate testpath/"xyls/apod4.solved", :exist?
    assert_predicate testpath/"xyls/apod4.wcs", :exist?
  end
end
