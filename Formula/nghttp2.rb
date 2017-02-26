class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.20.0/nghttp2-1.20.0.tar.xz"
  sha256 "2b2b78915284f32d86c80cd8037b8e5f8c9e94f8a98f674a45cdfb79b863ce62"

  bottle do
    sha256 "8ead350cc5b39a23c8c04d22baf810d311b193ce9f3cd1eb2808539f2d81dec4" => :sierra
    sha256 "d4ff5fe7aa4a878552250b14e97d7336d2066d51f262ec5ae99c967d0970ab55" => :el_capitan
    sha256 "96a15d89b9072b338c1a074f1c095f7f98e6bbf4f7453c4e7fe3f68131e0897d" => :yosemite
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-examples", "Compile and install example programs"
  option "without-docs", "Don't build man pages"
  option "with-python3", "Build python3 bindings"

  depends_on :python3 => :optional
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "c-ares"
  depends_on "libev"
  depends_on "openssl"
  depends_on "libevent"
  depends_on "jansson"
  depends_on "boost"
  depends_on "spdylay"
  depends_on "jemalloc" => :recommended

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b7/67/7e2a817f9e9c773ee3995c1e15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
    sha256 "f141d1f9c27a07b5a93f7dc5339472067e2d7140d1c5a9e20112a5665ca60306"
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
      --with-spdylay
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
