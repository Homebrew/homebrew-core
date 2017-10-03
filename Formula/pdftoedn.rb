class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"
  revision 4

  bottle do
    cellar :any
    sha256 "4a345cdb1689d16c02c37ed834bc53e264dba8dc4ce9f7c6eb243ca75aded2d8" => :high_sierra
    sha256 "2ff40b256a61a485728401d370e7c6b1670c5100a0f069463005c53dd5638d8f" => :sierra
    sha256 "b5e5c8c04acf1d1ee8e679779492c0a1db134c494bd1aa4d762ede4a6b0ddcd3" => :el_capitan
    sha256 "5c7f365a103ff540951e22185f1c73a7c5bc43ccb5280b28b9bf870042fe52d9" => :yosemite
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
