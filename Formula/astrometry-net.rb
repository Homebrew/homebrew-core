class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.79/astrometry.net-0.79.tar.gz"
  sha256 "dd5d5403cc223eb6c51a06a22a5cb893db497d1895971735321354f882c80286"

  bottle do
    cellar :any
    sha256 "cb0300becf79b6cfaed610b1a597aad73cc4a01dc7d35c860ada294933a52086" => :catalina
    sha256 "3cb90e5f8cf720be409d0b1e2562b5efaa874695c67331e48ac2add01ac3fd96" => :mojave
    sha256 "a85dc3730566d2da35afa3d7730c0db7f2c5d67a94d89f4a17f2d985a16529e2" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/d4/51/57074746cb7c9a7f5fe8039563337fbb1edabbc2c742d2acb99b1b7c204c/fitsio-1.1.0.tar.gz"
    sha256 "b1a8846d11c3919ea75cca611de9f76bfbdf745c4439e89e983d8a6bcfb92183"
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
