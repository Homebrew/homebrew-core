class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.51.zip"
  sha256 "3e7bb24a9e492f5cb86daca34054c9787152f1d7b70add36b789d03816d5ffa1"

  bottle do
    sha256 "d0f9d954e6c4fde8f44685d593306b08b87dd8d8d531c7c80271fa674fcff1b5" => :sierra
    sha256 "af2691eec1a1a85141a96f5682885f3da8d2de50b8d804a4b2f0f94aa89fc891" => :el_capitan
    sha256 "e6e7ef7e75142bac715c70e85d0190237722efc3b95aafc9b4761ae8562f3c5f" => :yosemite
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
