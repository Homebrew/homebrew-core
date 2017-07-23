class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.49.zip"
  sha256 "520909edb975ec7fc63aa1b404993a79c1b8f6a0d80bca588c03cfa5fec12410"

  bottle do
    sha256 "4f0b1e8855dec786df39dcc0e77be468bbad43e8fbb45a98f4648484a220822f" => :sierra
    sha256 "63e2a78b0ac6cac297b8b772821d49d065b2f09ed33ccb298b2e145b5ce78960" => :el_capitan
    sha256 "57a205654765889cad4082669b187296ae7ff28b6c71876f870d984aebb1dbad" => :yosemite
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
    assert File.exist?("calc.add.req.xml")
  end
end
