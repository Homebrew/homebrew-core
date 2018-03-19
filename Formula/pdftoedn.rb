class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"
  revision 9

  bottle do
    cellar :any
    sha256 "4fc97134436c7bdd1828ebebb96d65eb057527c28b575c25ca3e78e76683af5b" => :high_sierra
    sha256 "87b3ef2f5c6a537e50be27908a432fe002e1d7cb382893b1757d610baf45e40d" => :sierra
    sha256 "82209b75cd94bf2bb93edc6aa259d01d348398a386b6301d0fe55c8b94f62f6f" => :el_capitan
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
