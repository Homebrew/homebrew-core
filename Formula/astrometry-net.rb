class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.82/astrometry.net-0.82.tar.gz"
  sha256 "20f7ac7474962546f462286178e40b09602eeda10af98c828c64f67771fbc197"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "0dbb08fbe89c6e19d33d98d948ac84501aecd36c309db8681ec562e0236d5b5c" => :catalina
    sha256 "b301f3ab4452bcb22112ef48251ea808db617e08bdbbef09e7ac1290b767b4c7" => :mojave
    sha256 "4cd56fd0e0edce37e59860fd316e9bbcd3bde39859429dea971adacfbef946d8" => :high_sierra
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
  depends_on "python@3.8"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/5e/d7/58ef112ec42a23a866351b09f802e1b1fa6967ac01df0c9f3ea5ee8223ce/fitsio-1.1.2.tar.gz"
    sha256 "20e689bdbb8cbf5fc6c4a1f7154e7407ed1aa68e2d045e3e2cd814f57d85002f"
  end

  def install
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
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
