class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.8.tar.gz"
  sha256 "291b107cf6d385f29da4708f9c346a1f9a90dceb19bc4bf827ca848e56157fe9"

  bottle do
    cellar :any
    sha256 "3440506c5c588839cdb858c305ade0dd1cda2c0cd88456443eac068aa78aaf9d" => :mojave
    sha256 "72495a9931d740f3608e7d7b8359abb053c2c92877042321b9ba12798d9a12cf" => :high_sierra
    sha256 "2cc7101e9385b2eb68d23d27d7e9187a2a995fce235d01f13cf365e0a46fe23a" => :sierra
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
