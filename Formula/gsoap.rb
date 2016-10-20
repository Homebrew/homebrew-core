class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.36.zip"
  sha256 "20f70db768062e094ec3749073bfc4103cacaac8cab2cdbd624634ae496eef21"

  bottle do
    sha256 "f2a896457de6b0950af5e67589b332506285aeb28814699b5ab7ea70607d9891" => :sierra
    sha256 "704d31b11fe07537bff81d0b85187e252f818b8e4d98de0695e2c70ba5979213" => :el_capitan
    sha256 "e9fba31eb202103a36da3ecad59bbd856137a290e396c439947de2b6369aeb28" => :yosemite
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
