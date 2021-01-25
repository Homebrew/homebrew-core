class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.82/astrometry.net-0.82.tar.gz"
  sha256 "20f7ac7474962546f462286178e40b09602eeda10af98c828c64f67771fbc197"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "700e922e70fab4f449c5167c376cc2105d94d72c1ffbc674cfc8a40f15527338" => :big_sur
    sha256 "7f0d280c3cee7baef3f06bb9fa3ff52be07fa94a94f71192a9bf65e94285ab72" => :arm64_big_sur
    sha256 "341deb97e8b97022dba091f90eb564fb69993e686a7e3ce4f5ecee824f99a572" => :catalina
    sha256 "c21290e658b447a4ee10e33c6f0924ba7224bf31863e2541cb2ee502781cec28" => :mojave
    sha256 "da1ed3b61a7388044bc0b40fc58f9b9d1ecc2b27df25ff47596980b56edc82ad" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/5e/d7/58ef112ec42a23a866351b09f802e1b1fa6967ac01df0c9f3ea5ee8223ce/fitsio-1.1.2.tar.gz"
    sha256 "20e689bdbb8cbf5fc6c4a1f7154e7407ed1aa68e2d045e3e2cd814f57d85002f"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV["PY_BASE_INSTALL_DIR"] = libexec/"lib/python#{xy}/site-packages/astrometry"
    ENV["PY_BASE_LINK_DIR"] = libexec/"lib/python#{xy}/site-packages/astrometry"
    ENV["PYTHON_SCRIPT"] = libexec/"bin/python3"

    system "make"
    system "make", "py"
    system "make", "install"

    rm prefix/"doc/report.txt"
  end

  test do
    system "#{bin}/image2pnm", "-h"
    system "#{bin}/build-astrometry-index", "-d", "3", "-o", "index-9918.fits",
                                            "-P", "18", "-S", "mag", "-B", "0.1",
                                            "-s", "0", "-r", "1", "-I", "9918", "-M",
                                            "-i", "#{prefix}/examples/tycho2-mag6.fits"
    (testpath/"99.cfg").write <<~EOS
      add_path .
      inparallel
      index index-9918.fits
    EOS
    system "#{bin}/solve-field", "--config", "99.cfg", "#{prefix}/examples/apod4.jpg",
                                 "--continue", "--dir", "."
    assert_predicate testpath/"apod4.solved", :exist?
    assert_predicate testpath/"apod4.wcs", :exist?
  end
end
