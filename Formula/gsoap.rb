class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.69.zip"
  sha256 "df0cc9ab66dce85f1842ca07abebaf9b04ca48a0a39013f90571e8172d4b0c7b"

  bottle do
    sha256 "c5969928177671d714dca7317f4bc8688d86f14bd6c0b8821576dd127e1065e2" => :high_sierra
    sha256 "a70c67df1b4d6ab270deb5d202fc035f8879db31262d2c65767dd4de2589f7e8" => :sierra
    sha256 "66189df3d92cdb93a80ae564be571e2e450ce9600bf3ecfe3bf5a54be776710b" => :el_capitan
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
