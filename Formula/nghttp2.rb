class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.36.0/nghttp2-1.36.0.tar.xz"
  sha256 "e9bb86157b88eda5a6844a232e039febbb52c1aa44b640acbbfabe729b8287fc"

  bottle do
    sha256 "3df6011e98f13af091fcc9e4c759d9e9662ee4d9a863d88284e17b461c94be92" => :mojave
    sha256 "9c21365ecf3717afe8fda8307c8b80902d7b1f24275e45b8c8458ecc5e42560c" => :high_sierra
    sha256 "cb7ca00e18e43bab469ae685713bf43bd56067cd8395ad0c5921a4c9343726b9" => :sierra
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
  depends_on "openssl"

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
