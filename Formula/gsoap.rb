class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.65.zip"
  sha256 "34f20170afdeb355cb3a42d87e17efb3fbb299566588d7bd9c30dd1ec02f69c7"

  bottle do
    sha256 "bf796ee34d2bb913d813b418a025e732463f03810c501b6d6c10002e54f64396" => :high_sierra
    sha256 "03df081586b9f013bf2104515c8c1982262aad918d9a8368f0e518c0c9deb7db" => :sierra
    sha256 "79092eab6741e3aa18619eed29a78c7f99c183f32ebdadb72818cd8e18163f55" => :el_capitan
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
