class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.17.tar.bz2"
  sha256 "d8389763784a531acf7f18f93dd0324563bba2f5fa3df203f27d22cefe7a0236"
  revision 1

  bottle do
    cellar :any
    sha256 "7946cea648a8453c0d4bd3ec1be3a3b0ef885691c51123dd1e5e252b95e0a06d" => :mojave
    sha256 "4383c9c0681964915b3a3fe31d26178724e0f856725271e491dbf400dfeffa7e" => :high_sierra
    sha256 "e6c4e0b96b72c727a01f3b35cb743215a1ab4540c509c694d5f0e5ead1293244" => :sierra
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
