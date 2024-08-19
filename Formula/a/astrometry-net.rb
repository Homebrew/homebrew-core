class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.95/astrometry.net-0.95.tar.gz"
  sha256 "b8239e39b44d6877b0427edeffd95efc258520044ff5afdd0fb1a89ff8f1afc0"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "681664bdc8381e23fe4210d23e12950648f2c0b356fa897047ebabbae7aa18be"
    sha256 cellar: :any,                 arm64_ventura:  "0049fe69dcfa6a6a822f73dcf126e347510d50269d50034c15b7594aff317de1"
    sha256 cellar: :any,                 arm64_monterey: "f99643266e57f488814848732bf1ef8400f5c2a8cd1f326f54fa0237a489006f"
    sha256 cellar: :any,                 sonoma:         "574dae103e0381b66d6b94e2bd4b7bb4ec4806d72f6601712ca3e67ba82cdef3"
    sha256 cellar: :any,                 ventura:        "069e7081981b182a91479b4ae449a9a542fe4000301cb405c8b0ad8a60cd6e6a"
    sha256 cellar: :any,                 monterey:       "b90eb143ad2c5af39f8e4ec6981490e1aba97ba2780788abf8716c72b51f7e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d547674c49913efdb2fc5bce77af258e727d22dc29db604e0a209935d10068"
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
    url "https://files.pythonhosted.org/packages/6a/94/edcf29d321985d565f8365e3349aa2283431d45913b909d69d648645f931/fitsio-1.2.4.tar.gz"
    sha256 "d57fe347c7657dc1f78c7969a55ecb4fddb717ae1c66d9d22046c171203ff678"
  end

  # Support numpy 2.0
  patch do
    url "https://github.com/dstndstn/astrometry.net/commit/5640e60401ac6961449d64ec0256c326b1d26216.patch?full_index=1"
    sha256 "7486d9dac6bf7261f2cd459af028426dfb29c0b3c23c840889ef9ba083c42be3"
  end
  patch do
    url "https://github.com/dstndstn/astrometry.net/commit/7991b0d20280e8fc6a9b17d5669312eee69e4c43.patch?full_index=1"
    sha256 "4fa0feec1bd4159749789c5f115dd0e99e6a92e6032b90da273560a9064419d5"
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
