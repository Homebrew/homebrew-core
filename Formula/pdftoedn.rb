class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.34.3.tar.gz"
  sha256 "7ff6d097d1a53246b3c71d9fdaeb58e43aac14291f647d76855c62769c585f25"
  revision 7

  bottle do
    cellar :any
    sha256 "0971390fb279ec2e9a83cbbd9c96ac3581f287a38ca873b6279d1432d774e4ac" => :high_sierra
    sha256 "1f8db5ce3d87da185c95df9f69a7f84c8771448504f3ae1df14c9f4d6f22cf28" => :sierra
    sha256 "418404339226b21e44c07c8a553f30a0a28e9f0442ad079dcaa3feaadf04ee8d" => :el_capitan
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
