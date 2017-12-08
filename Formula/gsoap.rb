class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.56.zip"
  sha256 "10374c8ba119cf37d77ad8609b384b5026be68f0d2ccefa5544bc65da3f39d4c"

  bottle do
    sha256 "9f64e93e6c01176774ae19408e3eeb5a66f4ab55a9030bbda6e22203f9709a7b" => :high_sierra
    sha256 "7739b8091ce876d6ad9a0660d184bdd65705ec7ebe3fb2a61996ec1e468c8b12" => :sierra
    sha256 "2fa2bbef26238188b0b8ccb4f91fee64983d6c2abcdf62b5288857a42a1a7dac" => :el_capitan
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
