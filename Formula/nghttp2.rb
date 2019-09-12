class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.39.2/nghttp2-1.39.2.tar.xz"
  sha256 "a2d216450abd2beaf4e200c168957968e89d602ca4119338b9d7ab059fd4ce8b"
  revision 1

  bottle do
    sha256 "e2c689aaea97495a120f6fd923484a061a016bfcaa9084689e4737f41d73c964" => :mojave
    sha256 "fd9f5886356495b019830d38e3d041e8bc524a80a92ba4ccc811badb3ee9b3ee" => :high_sierra
    sha256 "55ea2f944214fad0b946a194d0e43c256345290581670922c397d187a560ee13" => :sierra
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "c-ares"
  depends_on "jansson"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-python-bindings
      --with-xml-prefix=/usr
    ]

    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
