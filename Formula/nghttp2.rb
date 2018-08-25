class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.32.1/nghttp2-1.32.1.tar.xz"
  sha256 "71ad04489b8e52df23a80166dfbf29d39bc48e39bc081e1e83ca8c94feeab7d0"

  bottle do
    sha256 "436d39dec9de8faba2415b758ec14ce4947ceef44f18638e05f9055c21509712" => :high_sierra
    sha256 "a59e874fc0b5be7a6ce0615e8e70f1db115ae06d517287cb920c1f02e438ef16" => :sierra
    sha256 "9b2aa96154cf0cd7bee3bef31ad505b7163878fb7e6067faf529bcc23e348106" => :el_capitan
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-examples", "Compile and install example programs"
  option "with-python", "Build python3 bindings"

  deprecated_option "with-python3" => "with-python"

  depends_on "python" => :optional
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
    url "https://files.pythonhosted.org/packages/79/9d/dea8c5181cdb77d32e20a44dd5346b0e4bac23c4858f2f66ad64bbcf4de8/Cython-0.28.2.tar.gz"
    sha256 "634e2f10fc8d026c633cffacb45cd8f4582149fa68e1428124e762dbc566e68a"
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
    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan
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

    if build.with? "python"
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
