class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.80/astrometry.net-0.80.tar.gz"
  sha256 "6eb73c2371df30324d6532955c46d5f324f2aad87f1af67c12f9354cfd4a7864"

  bottle do
    cellar :any
    sha256 "d6084649d9cb51778b0a8c93d0c52024ac9c65d43be14580ccd13b4e069fa09a" => :catalina
    sha256 "faff9789727379b868afa5c20c0d9d6d53ce5e1e5d012df0609d31de5b99c5d0" => :mojave
    sha256 "07a494a2a39c9e36cdf10c5eca39039a97f11c211db77d62b0968623fb7da136" => :high_sierra
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
    Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")

    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON_SCRIPT"] = Formula["python@3.8"].opt_bin/"python3"
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV["PY_BASE_INSTALL_DIR"] = libexec/"lib/python#{xy}/site-packages/astrometry"
    ENV["PY_BASE_LINK_DIR"] = libexec/"lib/python#{xy}/site-packages/astrometry"

    system "make"
    system "make", "py"
    system "make", "install"

    rm prefix/"doc/report.txt"
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"
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
