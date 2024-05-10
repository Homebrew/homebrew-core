class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.95/astrometry.net-0.95.tar.gz"
  sha256 "b8239e39b44d6877b0427edeffd95efc258520044ff5afdd0fb1a89ff8f1afc0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6fb8ec426f755ef1b4ddbd3f1ea03dc3aaacf5cfd5d6a80cfa874979ffe5a38"
    sha256 cellar: :any,                 arm64_ventura:  "fd49a3b2aba7ad52ec114e219297f4388edda04b58139d4368cd78faab41742a"
    sha256 cellar: :any,                 arm64_monterey: "798d42abbd899d65406336e91ae16b8a42797bfed8e13cda63265d380ca2f2a1"
    sha256 cellar: :any,                 sonoma:         "b8e1278ffd89f28c523d5d03610a840bde224813ae379096aa340d8d6ddf3a59"
    sha256 cellar: :any,                 ventura:        "655b0157dafd37b4454ea03d9b1260f90dc28de8b05f6f381f295765d0a5f0dd"
    sha256 cellar: :any,                 monterey:       "e410667649f2c55410a5ade1245c0ca54bbee8983bec0a1025112dd0957731dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9dd3a68a30bdcce2f24e8852237cfa21590307e3ef09dbd7a3d10db32623bab"
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
