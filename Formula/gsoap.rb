class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.98.zip"
  sha256 "56460362ca8f9decdf880d82601e50ae13fb2185582a704b037060acacb7fc3a"

  bottle do
    sha256 "a4a7949ac587ce0dc43849d5d8fbed38b9571d504b6c8af7db1ba3bf8a779e68" => :catalina
    sha256 "44bbe46df4293c171b1f99603f828391c4616784c8d014c6101c7ea582bd03b2" => :mojave
    sha256 "0f1c164348d7aa8f85b1ce13413f3753f024c96365246c0e1452a7d0fab6ee5c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel. However, issue persists as of 2.8.89.
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
