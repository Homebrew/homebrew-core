class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"

  stable do
    url "https://github.com/nghttp2/nghttp2/releases/download/v1.34.0/nghttp2-1.34.0.tar.xz"
    sha256 "ecb0c013141495e24bd6deca022b5a92097a7848a0c17c4e5af1243a97fa622e"

    # apply upstream patch to fix compilation on macOS, remove in next release
    patch do
      url "https://github.com/nghttp2/nghttp2/commit/153531d4d0ebe00ac95047dbf1fec1d9d694f29f.patch?full_index=1"
      sha256 "7b520ff66699dd41a84cbd287c06ed474ef21ce2b2fab34152267ac1d8ec07da"
    end
  end

  bottle do
    sha256 "a0a79d8de3450162bf674dcf8a6dec4f293f814542ea6c3499401988eab5fe6e" => :mojave
    sha256 "d3c1efec430bbb8ac88ac24583100a561018a5b80039208478e781f8aceaf1e8" => :high_sierra
    sha256 "a94cbf23943a9892a100227a68aa29c3164d4a16219fb8c76e0752f43a864f58" => :sierra
    sha256 "3988e15fb6b5392e5c57f2b6cd710309afc065675892fca42b9b9aac075c5a18" => :el_capitan
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
  depends_on "boost"
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
      --with-boost=#{Formula["boost"].opt_prefix}
      --enable-asio-lib
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
