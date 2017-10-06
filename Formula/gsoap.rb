class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.54.zip"
  sha256 "158ed9c674941c382850e8e96ac9b0174f4e7aacb25794349bd07f52261921c8"

  bottle do
    sha256 "ecb620b1ce7dca9aac94f83ca6f5ad8a1e304118dbe47ebdba4283a81060108c" => :high_sierra
    sha256 "0b2d2e9bbc46470fb53f832c6745037b5843f2d48d762795ea5f51451163a959" => :sierra
    sha256 "d12f03a42dc55ec64d99ce3680d8883f88ffc620d38265364d873b62ba0dc3e1" => :el_capitan
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
