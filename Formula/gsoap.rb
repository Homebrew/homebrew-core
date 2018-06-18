class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.67.zip"
  sha256 "53c56fb365ed24195fffdad7c589d073f1e4e467901a6b60e1fd5158d61e47cf"

  bottle do
    sha256 "6ab5d80faa6dfdf9e3be9f9eb141733364e31d0058fc429b46f8516431ec779a" => :high_sierra
    sha256 "d0591bf14645cd780908e9f4f1b9f9e3670e1fc26351f4252939eb95cbe99204" => :sierra
    sha256 "b5fe027097a18af9f4254cf53b4e2ea9a2ea1c6ca96a5f13074b9faf15ca1d27" => :el_capitan
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
