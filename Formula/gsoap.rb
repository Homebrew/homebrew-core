class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.64.zip"
  sha256 "221213dd9ba398e4e568ae24d545607c4177f04d3920a6195d9db66a64a69030"

  bottle do
    sha256 "bbbd212bcf5081e66e24bf5890e0dc38771cf6887e9bbeb213aaf84e96281b3d" => :high_sierra
    sha256 "b355e9d3abf0281e0161aece9cadf6b0778fcdc620fa75078eca4ba13651025a" => :sierra
    sha256 "19ee666aa98529b0964a1a6c4f4077517fa17d0d8ad949a6cfe4c0c70580b6ce" => :el_capitan
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
