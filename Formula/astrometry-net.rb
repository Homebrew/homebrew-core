class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.85/astrometry.net-0.85.tar.gz"
  sha256 "e5aa28cbd6c5dd2eaf6df68f95398c3cae190668d86e9922521d29689fc27221"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "83e1307f40aa32d8815abc05f871386ae9d21e02dac40a4a42135e5701328154"
    sha256 cellar: :any,                 big_sur:       "48ce09c0a007ff83c025e87f62ae388ef70c855f1ce5fbb507228b2b9384d13b"
    sha256 cellar: :any,                 catalina:      "812735fc4b3038e7004693d8f59bd81e434edc0ed2b5334e634259fdf8071074"
    sha256 cellar: :any,                 mojave:        "ec10f1e44c5dfdb49e290cb180d30945d69c100514a07b2c3a07da3f9dff88db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12548d700b89741f91aa2d9371fac5a95aca3066d5d2769eb9c0b58226aca90"
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
    url "https://files.pythonhosted.org/packages/98/2b/0b36a6d039d10da5bfa96d0d6206523f8787fbcc4b8aa0b8107e5139b8b4/fitsio-1.1.4.tar.gz"
    sha256 "59c281648ea8fe50ed557857b201eacb21671b83ae60956a7e22c2a7e2a82b9d"
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
