class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.17.tar.bz2"
  sha256 "d8389763784a531acf7f18f93dd0324563bba2f5fa3df203f27d22cefe7a0236"
  revision 1

  bottle do
    cellar :any
    sha256 "bc89ba7b6a450258f82ccc9e3ade05012847d9bec37ae1a52e6902695ffc39f9" => :mojave
    sha256 "e32a0dfddba4e773520e8f33834fcfbcc5ec8d4d6ebefb7527de3e964d865522" => :high_sierra
    sha256 "17b63c4b6fc92b9d735f2c44c3cf4cad60c3e69a73e0397d17bb7b21c4907707" => :sierra
    sha256 "910088e2b13e329c7f783e68ced98a1bfe7fa84ee266087fbd665248f852b78e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl"
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

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
