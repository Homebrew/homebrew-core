class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.7.tar.gz"
  sha256 "6e3d54d2bd39184c37167783805558c4ebf37dbc6e5acbe9d516bd5a4d1b37dc"

  bottle do
    cellar :any
    sha256 "b651e7a667178961718818c9d4baefd05579bdb638e9587febd1399e56fef0d4" => :mojave
    sha256 "7866510ea616209a30cf1974a2a8a6fd029dd21b038fa9e384fdd6e36ae7430b" => :high_sierra
    sha256 "318c316208874abdafd59c8d64332b1592ccf95cc15d23d1a730a740d8e63b36" => :sierra
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
