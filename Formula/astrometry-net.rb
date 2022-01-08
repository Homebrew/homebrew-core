class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.88/astrometry.net-0.88.tar.gz"
  sha256 "f57d129547ad176a4ff04dc86fc7523d2e7437a9a7f9b567989b81db813b92d2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 catalina:     "2d399bbf32a6bda464f295ae0259eb975c9449d9f498a90748f19c3086da8cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "166200dca9b7ca7f3bced4322ade7242b1ab66d3d6c0dade57292d8b22f51429"
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
    url "https://files.pythonhosted.org/packages/23/ec/280f91842d5aeaa1a95dc1d86d64d3fe57a5a37a98bb39b73a963f5dc91d/fitsio-1.1.6.tar.gz"
    sha256 "3e7e5d4fc025d8b6328ae330e72628b92784d4c2bb2f1f0caeb75e730b2f91a5"
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
