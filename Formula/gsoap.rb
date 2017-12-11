class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.57.zip"
  sha256 "b27956be1105d99d769ab51b16cc45ec185b1ff501d4b7a73a2813708a9983dd"

  bottle do
    sha256 "db73b3e6b85c8ffbc5baaff21362ab89492c15502c8a4d8d09183c40c19a9366" => :high_sierra
    sha256 "ea0781a0e0ad93f2c6e922cbf80121e777d39f3ce6d2e5a3a512401a27d3cd2e" => :sierra
    sha256 "b2c943eb4282385620fc51c4658dd33756645e9fb47b89e02aa67ddbd5790d88" => :el_capitan
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
