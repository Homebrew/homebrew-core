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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "7f4f5d8b63f56580ab8358c167b88b4935edfd89c7a1f23795dd8cc17d7f7dd0"
    sha256 cellar: :any,                 arm64_sequoia: "92cd33a9b2b2e265f40fc41d8f3970db11b13fd5644e79bb25b59e9c35918300"
    sha256 cellar: :any,                 arm64_sonoma:  "ed304036c98a2e5b34afd683447e9ec731da0a932f4efd4583948ffa912cd0ab"
    sha256 cellar: :any,                 sonoma:        "5e5b7ea3ffc3f164fe4ef417ee07b3bd61635e0d013ad65a44750f949b868a39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f885845949e0b6399a00d2628b78b06576b2c89137ff308e1c5b708d6b36162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d90330bbdcaca59edfed36e5c276dbdfc4167fb0defff861fd94b23bdd28d52"
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
  depends_on "python@3.14"
  depends_on "wcslib"

  pypi_packages exclude_packages: "numpy",
                extra_packages:   "fitsio"

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
    ENV["PYTHON"] = python3 = which("python3.14")

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
