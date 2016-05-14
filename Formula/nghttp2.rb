class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.10.0/nghttp2-1.10.0.tar.xz"
  sha256 "c7e4624d91f32cddfd81233361804c004ef5295851b93e31f95f54a224e5091f"

  bottle do
    sha256 "b547328487f7a431019e153df75502aede77f593ded7193734393a0c773a8832" => :el_capitan
    sha256 "41d3dfa8604fb5dd0d6628ab67e35cef954624e61687ac6c871b9eb0755d2cf8" => :yosemite
    sha256 "2fb24307cae351a4d67d0b23ca4eaa0cfb6b7540e8c3e720c781a05272ae8ee3" => :mavericks
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
    url "https://pypi.python.org/packages/source/C/Cython/Cython-0.23.1.tar.gz"
    sha256 "bdfd12d6a2a2e34b9a1bbc1af5a772cabdeedc3851703d249a52dcda8378018a"
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
