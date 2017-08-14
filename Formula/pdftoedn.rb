class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"

  bottle do
    cellar :any
    sha256 "9e45e73140d5c3e527289cd82283e058a6e21cf087d40c911e82805879bd72db" => :sierra
    sha256 "e50875d654167a22ddf4de7e8489ed02437cf0936ef41695593f2461968d32a3" => :el_capitan
    sha256 "70489e29b27fc0e24dd2cfa9d6eda4b3090e51f2965ddc4e08b2195347296f79" => :yosemite
  end

  needs :cxx11
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "poppler"
  depends_on "boost"
  depends_on "leptonica"
  depends_on "openssl"
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
