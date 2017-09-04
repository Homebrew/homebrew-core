class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"
  revision 2

  bottle do
    cellar :any
    sha256 "41dbac992cf79513fa237f0f59bfe02f65ca0bb270a1f8e87ade8cb73b5677b5" => :sierra
    sha256 "3c811d9b53fad3a54c12c2a112c9f6d0a6c2d869bd08b40ee1dd43360975b03b" => :el_capitan
    sha256 "30486a29f7293bea13f31a6d882cb8367e97ee2e5994f38dff6b1cc29bf9a862" => :yosemite
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
