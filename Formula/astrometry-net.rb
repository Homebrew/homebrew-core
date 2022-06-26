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
    sha256 cellar: :any,                 arm64_monterey: "ab82820ca73b7ff92197bfc1fcdd424951ef3e946e4bdb17e780090df2d8cd46"
    sha256 cellar: :any,                 arm64_big_sur:  "c965cf45db269d7399ddf42dc5899df5e2fb4ef6d371260d15b7408a65604e42"
    sha256 cellar: :any,                 monterey:       "7a0fe0133ba37138b8ac9b05a603b42598cf512f047f4914cee223a31a79bfd7"
    sha256 cellar: :any,                 big_sur:        "8620d6be5c82ba6575b4641a6808940eca0eea0751724d3b705aaf6fd0d517be"
    sha256 cellar: :any,                 catalina:       "a00a127f86ce596651a613480b4bb682b4704e76dbeb325b046faf50753d5505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7ac288fb560fa9327ae3de30e4296e71674aa94066cdeb89666f20a70b1121"
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
