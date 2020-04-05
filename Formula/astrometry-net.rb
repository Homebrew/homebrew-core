class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.79/astrometry.net-0.79.tar.gz"
  sha256 "dd5d5403cc223eb6c51a06a22a5cb893db497d1895971735321354f882c80286"
  revision 3

  bottle do
    cellar :any
    sha256 "4152527a196add8840cd58fd7d9d8234b30373e067ec1bae29cf2b9d20289f99" => :catalina
    sha256 "65d9f537810a5a9eb3eabb6bcbe64b9961f313afd0f541550b4eba63160649a0" => :mojave
    sha256 "237224c405cf05b73485b9770ffe84f2ecb8e70a34901d25e588b7280d217d74" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/9c/7d/99906853351108cd5abea387240b5b58109a91e349f0ae22e33c63969393/fitsio-1.1.1.tar.gz"
    sha256 "42b88214f9d8ed34a7911c3b41a680ce1bdee4880c58e441f00010058e97c0aa"

    patch do
      url "https://github.com/esheldon/fitsio/pull/297.patch?full_index=1"
      sha256 "d317355af23101b2bc49b6844ac83061a6485f4fa9741b2ecae0782972bcd675"
    end
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

    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    system "make"
    system "make", "py"
    system "make", "install"
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
