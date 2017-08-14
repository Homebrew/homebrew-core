class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"

  bottle do
    cellar :any
    sha256 "730bcc44f0950bf7457ea2079c6d1224f05da3943e0155857e39ea9aaaf7a77b" => :sierra
    sha256 "4fd2548af0f00293b0fbe9ee6d242634769d3efc79155343ca7b7ed7cafc0088" => :el_capitan
    sha256 "7daf38023468ab13246f72e199fd9b17d0a0a3c5c84ca4f20066914f160e70b8" => :yosemite
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
