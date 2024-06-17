class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.95/astrometry.net-0.95.tar.gz"
  sha256 "b8239e39b44d6877b0427edeffd95efc258520044ff5afdd0fb1a89ff8f1afc0"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0abb91d2795ab69b56150eed0bff0fa88a8c3c5444a7fb2422cf04bde2e91300"
    sha256 cellar: :any,                 arm64_ventura:  "737e218aff30454c7d4612e9c39afd8b122352096bb31e582bef1f241be5a5a8"
    sha256 cellar: :any,                 arm64_monterey: "6347a4edbc9060417c3e34b67bfe421bda57a830712f2ff7ac52057164e3b216"
    sha256 cellar: :any,                 sonoma:         "78aedc0a6bc704c1389af6bd1f619ee0f1be866280d9d01343e6813706e6435d"
    sha256 cellar: :any,                 ventura:        "bedf5b70775e9621c702f9476bf63abf7b3ecf040f241f59cb9918435bfad118"
    sha256 cellar: :any,                 monterey:       "75c31c171f4a998864575be6c1b4dae8be056413f59652eac83e6924a540263c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925b6431debcb4a5266f00f77aceeba043ee15d652236428ac3ee91a048fe0ed"
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

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    ENV["FITSIO_USE_SYSTEM_FITSIO"] = "1"
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python3 = which("python3.12")

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
