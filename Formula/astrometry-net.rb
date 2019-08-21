class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.78/astrometry.net-0.78.tar.gz"
  sha256 "9eda1b6cab5269b0a0e5d610aec86866cb8b08fb8f56254dc12f1690d69bc649"
  revision 2

  bottle do
    cellar :any
    sha256 "1779cbaea8541ee9987f50d252566a84a145d4beb582d5022318305050879b59" => :mojave
    sha256 "5a1414ff53bf48bc14b18462f15da0f6ee49c16f5ef363f90ba5c6d3805e8b86" => :high_sierra
    sha256 "b1015bcaf96e66f01d2a7b9b00d54a3d476e5f166cb7f587611811f62c5c2fa9" => :sierra
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
  depends_on "python"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/87/c1/be76515a52004b261febf2c2074f0c2fd730b71b331e2cc69480952e1ed3/fitsio-1.0.5.tar.gz"
    sha256 "db5ac8d8216733f492007f1511dc0f77a8b6c0047aca35eb2148adc4a63a4d5a"
  end

  def install
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON_SCRIPT"] = "#{libexec}/bin/python3"
    ENV["PYTHON"] = "python3"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    xy = Language::Python.major_minor_version "python3"
    ENV["PY_BASE_INSTALL_DIR"] = libexec/"lib/python#{xy}/site-packages/astrometry"
    ENV["PY_BASE_LINK_DIR"] = libexec/"lib/python#{xy}/site-packages/astrometry"

    system "make"
    system "make", "py"
    system "make", "install"
  end

  test do
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
