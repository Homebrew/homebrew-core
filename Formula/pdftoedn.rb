class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.2.tar.gz"
  sha256 "a9d67dc980b0d52078092201d0f00f3f0d2c066c4e0b6148590e37e2fae6012c"

  bottle do
    cellar :any
    sha256 "8a834a7046506613985a9adbfb3cd2011e46922b282202bc92cfc95aa306ca30" => :mojave
    sha256 "db02a871af1c8f370368617f8afd8c8ae8541de0fe9bca99e1b4433f4ab0ccca" => :high_sierra
    sha256 "e9a565ab05716f5653fc9dac4590f3481a6cabefe0171d7f991123ba4e5b7879" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "openssl"
  depends_on "poppler"
  depends_on "rapidjson"

  needs :cxx11

  def install
    ENV.cxx11

    system "autoreconf", "-i"
    system "./configure", "--with-openssl=#{Formula["openssl"].opt_prefix}", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdftoedn", "-o", "test.edn", test_fixtures("test.pdf")
  end
end
