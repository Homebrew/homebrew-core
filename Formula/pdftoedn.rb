class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"
  revision 8

  bottle do
    cellar :any
    sha256 "c3e4266ef5af54b817896bcd7610f78871f0a212a2ee693b2824aa7d88c864f3" => :high_sierra
    sha256 "5a92b218fb720b852f9e64ac106592bf21bba39b6f39963605b37a5d2bad6fb2" => :sierra
    sha256 "507feb2bf38c50856d91a65a3680165cddf92d9320e268ecca13d6994b5168c1" => :el_capitan
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
