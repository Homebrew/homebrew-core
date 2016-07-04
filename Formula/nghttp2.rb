class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.12.0/nghttp2-1.12.0.tar.xz"
  sha256 "445c24243b8132b031c2c9fc9fe99f5abadbce2db4fbdf7eb6d3beaa5797dd4b"

  bottle do
    sha256 "9d75d6846e9402a9e2f4a84bd0af6f3fe49709ec070c413d5b6703b7bc46cd4e" => :el_capitan
    sha256 "47ad32e5319dcaa7461925d3a27e8eb065a4969a932cfede0b1c395698abe28c" => :yosemite
    sha256 "5aa502633f6e56501b80ee84b5c117829d0a55b4d83d9c521b1eaaf19dd7ca0e" => :mavericks
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "libxml2" # Needs xml .m4 available
  end

  option "with-examples", "Compile and install example programs"
  option "without-docs", "Don't build man pages"
  option "with-python3", "Build python3 bindings"

  depends_on :python3 => :optional
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "libev"
  depends_on "openssl"
  depends_on "libevent"
  depends_on "jansson"
  depends_on "boost"
  depends_on "spdylay" => :recommended

  resource "Cython" do
    url "https://pypi.python.org/packages/b1/51/bd5ef7dff3ae02a2c6047aa18d3d06df2fb8a40b00e938e7ea2f75544cac/Cython-0.24.tar.gz"
    sha256 "6de44d8c482128efc12334641347a9c3e5098d807dd3c69e867fa8f84ec2a3f1"
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
    ]

    args << "--enable-examples" if build.with? "examples"
    args << "--with-spdylay" if build.with? "spdylay"
    args << "--disable-python-bindings"

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
