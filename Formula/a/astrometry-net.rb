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
    sha256 cellar: :any,                 arm64_sequoia: "757f3c12578d021709e8332caa87e0d3ca1bcc28f39a675946d83cca07bc214e"
    sha256 cellar: :any,                 arm64_sonoma:  "8e37742770e1efe10c744f4a908c002af489a59e8aa2bf6c5cb4dbad74b02d74"
    sha256 cellar: :any,                 arm64_ventura: "12ea115da7ff9e7976e71bcb7e3f6ee7420f633a1c2295d24df6c95568aa28ba"
    sha256 cellar: :any,                 sonoma:        "f4115527d39d5d12b687a44b02556072ad48e0d982b445193e1ccb3fb2f42eb8"
    sha256 cellar: :any,                 ventura:       "acfb3cb5d86b8127c99a3ad33b874e3496e12bca06bf84252a70d49e33bf76df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fd9bce936b958783eed600b61cc2490a719aabbf631dc1f6624d058a5b7f6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92de421cb2c9161b9cc6a25bd364988041831bece5de023e55684350b0a03b3"
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
    assert_path_exists testpath/"jpg/apod4.solved"
    assert_path_exists testpath/"jpg/apod4.wcs"
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.xyls",
                              "--continue", "--dir", "xyls"
    assert_path_exists testpath/"xyls/apod4.solved"
    assert_path_exists testpath/"xyls/apod4.wcs"
  end
end
