class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.80/astrometry.net-0.80.tar.gz"
  sha256 "6eb73c2371df30324d6532955c46d5f324f2aad87f1af67c12f9354cfd4a7864"
  revision 2

  bottle do
    cellar :any
    sha256 "46a03003e70530c829daa38af5ca0768041a13aff07445dc5b3147d1ce406748" => :catalina
    sha256 "1974bbd293175be81985447fc6dcd3a2756cc5b8e07b2cc43a75e650baa79792" => :mojave
    sha256 "0a18f2feb70bc86a5a591b6255f530667239ee89126cc6e6e2509539babb29dd" => :high_sierra
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
