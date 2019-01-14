class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.36.4.tar.gz"
  sha256 "4714f2525a41574ad8601b5d68d82975615a52475088fa9f02e83ecb7a68b363"

  bottle do
    cellar :any
    sha256 "7e53b96f447baea58576a688c5c3befd58572de8248735b71c4e9ba444fea18c" => :mojave
    sha256 "247102a575acfbb7c8f10596c0646f1fdabb3e72767738dfc7f15e9c148016b1" => :high_sierra
    sha256 "9a0c5fdcdb031793063d460e503e11f6fc2d9e6804d4a5665c40ce8da0a58445" => :sierra
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
