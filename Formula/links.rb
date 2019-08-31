class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.20.tar.bz2"
  sha256 "3bddcd4cb2f7647e50e12a59d1c9bda61076f15cde5f5dca6288b58314e6902d"

  bottle do
    cellar :any
    sha256 "187e68bd2c25a81e2b383cb5ba1f8d633ded7fffb7bfe42984dc0ccf2a170467" => :mojave
    sha256 "b360bbfcbfed62643ac781c7f90d93bcfaea694f99ee27061f46b1ee7e006af0" => :high_sierra
    sha256 "3577ede16b0d1d591205841a9ed7044fa831eae9992830b5d4c066847fc92dce" => :sierra
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
