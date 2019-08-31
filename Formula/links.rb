class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.20.tar.bz2"
  sha256 "3bddcd4cb2f7647e50e12a59d1c9bda61076f15cde5f5dca6288b58314e6902d"

  bottle do
    cellar :any
    sha256 "92a5a7e13256630bdcb5292005b03a99712c1096aaff56c6e6685f63116bafa2" => :mojave
    sha256 "f5bef932d1d066d0b0a33471a2e9a2ab6bea524366d8220f76b146f0f46a68b3" => :high_sierra
    sha256 "02b4c4a9f6495448e653242ddae98a0fbd482af3918c3dcd5f548337fb609e2f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
