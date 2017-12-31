class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.59.zip"
  sha256 "fe5631df7fc840ac71def03be8fe1c55f2e8de2affe60ea64bb0f083e857ca5a"

  bottle do
    sha256 "ea9d821cdaaf084978062f3a5637749fa42341f13870ed257420298a1328fe9b" => :high_sierra
    sha256 "62c047f20b97743a9a25367e21d8bf5a7ef33f595eca00774140c1f1524e7b11" => :sierra
    sha256 "610baacbe1e2d25d15040ac2115befef6083aa3c85d563673f9931442d968709" => :el_capitan
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
