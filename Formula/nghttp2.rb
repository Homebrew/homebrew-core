class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.35.0/nghttp2-1.35.0.tar.xz"
  sha256 "23610ddd446bf1a9ae12905b0e7f283afd46249794868b7acd581e693900544c"
  revision 1

  bottle do
    sha256 "e52ffb4ae9629f1f4693c96c2e6625b446a61a376a510fc20bb96845e58b3981" => :mojave
    sha256 "95f791e06ed5fbe0eed90941bf6b6365eed1f21c000950c0cb094a79d702cf14" => :high_sierra
    sha256 "f95664923bc9c6a935098128e9e459cb125005f73dcb06efcd2470d95d3e6166" => :sierra
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-python", "Build python3 bindings"

  deprecated_option "with-python3" => "with-python"

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "c-ares"
  depends_on "jansson"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libevent"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "openssl"
  depends_on "python" => :optional

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/f0/66/6309291b19b498b672817bd237caec787d1b18013ee659f17b1ec5844887/Cython-0.29.tar.gz"
    sha256 "94916d1ede67682638d3cc0feb10648ff14dc51fb7a7f147f4fedce78eaaea97"
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
      --disable-python-bindings
    ]

    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan
    args << "--with-xml-prefix=/usr" if MacOS.version > :lion

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

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
