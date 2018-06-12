class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.67.zip"
  sha256 "53c56fb365ed24195fffdad7c589d073f1e4e467901a6b60e1fd5158d61e47cf"

  bottle do
    sha256 "8805ff231e99d7778118ee41f009698f9395ff6342cf83388955091d468fcb63" => :high_sierra
    sha256 "3a887888fd01d5f66e6cc5f94c883ca6d2077ec6dc7eb68befec9aba5a1a59b7" => :sierra
    sha256 "918771ea1772baab426b55aa004eea7c4a71dea1033a1aac5dbb30d2eb071833" => :el_capitan
  end

  depends_on "openssl"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel.
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
