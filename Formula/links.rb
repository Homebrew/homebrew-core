class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.16.tar.bz2"
  sha256 "82f03038d5e050a65681b9888762af41c40fd42dec7e59a8d630bfb0ee134a3f"

  bottle do
    cellar :any
    sha256 "5938f6b6a381086e00856b1386b8bc2baad63bb37aea7b456ad8acfd47737f2f" => :mojave
    sha256 "8e70c80765c28eaec7146aaa806d3294e1857f06148c21900f7e4e505c561495" => :high_sierra
    sha256 "d26fabd7bc2111c443b5c3169ed5f4c246e5d0a234cb7da98ff040e83ff1e232" => :sierra
    sha256 "72b090e5cd35aced4c32e269ce546c4f39184f94b6efa4214e01f520ea666aee" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "libtiff" => :optional
  depends_on "jpeg" => :optional
  depends_on "librsvg" => :optional
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-lzma
    ]

    args << "--enable-graphics" if build.with? "x11"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-librsvg" if build.without? "librsvg"

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
