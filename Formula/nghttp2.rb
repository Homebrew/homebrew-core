class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.30.0/nghttp2-1.30.0.tar.xz"
  sha256 "089afb4c22a53f72384b71ea06194be255a8a73b50b1412589105d0e683c52ac"

  bottle do
    sha256 "113580a4da9ead2037675ffb797d7650430f9db00ef7ef32176ed579a25a9355" => :high_sierra
    sha256 "f48ac4ed9ecfd676eafe40ef8207116522643086499f338a6cea3f4013b36aed" => :sierra
    sha256 "5ce979de1d8de1e385eafcc05fba27aa7d1b0496a76b9e672cfcc8a2f7d52090" => :el_capitan
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-examples", "Compile and install example programs"
  option "with-python3", "Build python3 bindings"

  depends_on "python3" => :optional
  depends_on "sphinx-doc" => :build
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "c-ares"
  depends_on "libev"
  depends_on "openssl"
  depends_on "libevent"
  depends_on "jansson"
  depends_on "boost"
  depends_on "jemalloc" => :recommended

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/ee/2a/c4d2cdd19c84c32d978d18e9355d1ba9982a383de87d0fcb5928553d37f4/Cython-0.27.3.tar.gz"
    sha256 "6a00512de1f2e3ce66ba35c5420babaef1fe2d9c43a8faab4080b0dbcc26bc64"
  end

  # https://github.com/tatsuhiro-t/nghttp2/issues/125
  # Upstream requested the issue closed and for users to use gcc instead.
  # Given this will actually build with Clang with cxx11, just use that.
  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --with-boost=#{Formula["boost"].opt_prefix}
      --enable-asio-lib
      --disable-python-bindings
    ]

    args << "--enable-examples" if build.with? "examples"
    args << "--with-xml-prefix=/usr" if MacOS.version > :lion
    args << "--without-jemalloc" if build.without? "jemalloc"

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"

    # Currently this is not installed by the make install stage.
    if build.with? "docs"
      system "make", "html"
      doc.install Dir["doc/manual/html/*"]
    end

    system "make", "install"
    libexec.install "examples" if build.with? "examples"

    if build.with? "python3"
      pyver = Language::Python.major_minor_version "python3"
      ENV["PYTHONPATH"] = cythonpath = buildpath/"cython/lib/python#{pyver}/site-packages"
      cythonpath.mkpath
      ENV.prepend_create_path "PYTHONPATH", lib/"python#{pyver}/site-packages"

      resource("Cython").stage do
        system "python3", *Language::Python.setup_install_args(buildpath/"cython")
      end

      cd "python" do
        system buildpath/"cython/bin/cython", "nghttp2.pyx"
        system "python3", *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
