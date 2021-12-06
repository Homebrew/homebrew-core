class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.89/astrometry.net-0.89.tar.gz"
  sha256 "98e955a6f747cde06904e461df8e09cd58fe14b1ecceb193e3619d0f5fc64acb"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7afe58ce0dab463c33b97a2c58953c4f4b16a003ebb47a3610d69d421bf5d00"
    sha256 cellar: :any,                 arm64_big_sur:  "d2afa0d633db5038cc794410b5c745a27258280bfec1a893e3d6624971bebfe9"
    sha256 cellar: :any,                 monterey:       "69f5e96dd60d878142c9f36eeee3d77ef9f0f8e4b33cb4e6f5c260b6aa7c900d"
    sha256 cellar: :any,                 big_sur:        "7ed9aeb4990c71a9f3fc972b6fd929f63678bcfb99168465511b6316e5969108"
    sha256 cellar: :any,                 catalina:       "2cbcf4b5f0f67a0a96a1f013d5276ee60f60fe4cb0dfb0217a3e52e2baf1e35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ada7188cce602a939ce3e7587ead2e83630d4dd5e3a4d54095a127f68e69e8ae"
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
