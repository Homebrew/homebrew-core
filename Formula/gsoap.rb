class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.60.zip"
  sha256 "65bbf907533857056344c2a014416078ae4d3b5a3f559d67fa9a62a7e3efcacd"

  bottle do
    sha256 "8fee51ca6a140988875b73016de7e085c38bd7c4650aa2c17c63d5af82b90b11" => :high_sierra
    sha256 "90e3a89dde84448e5babfffdf4190a95e847d910596a3c2f08a12db71af3d0f2" => :sierra
    sha256 "cba0d81e226d3d958df5a905b35dcc37ccc63de845ff455079466fd94cf51c77" => :el_capitan
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
