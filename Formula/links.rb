class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.19.tar.bz2"
  sha256 "70758c7dd9bb70f045407900e0a90f1114947fce832c2f9bdefd5c0158089a0a"

  bottle do
    cellar :any
    sha256 "eaa37994f1e8b6c4b940e2d9ef8bb54e87ad78a9abf2e2318f3b876793b18e7c" => :mojave
    sha256 "8a2c300d607c3ded56d50d7c953ec9b574de9d734701ab4399cce3a472c95996" => :high_sierra
    sha256 "d069f957d246521cafefeabc64104504f286a8634e97731f729ab6592acd47dd" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-lzma
    ]

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
