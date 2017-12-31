class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.59.zip"
  sha256 "fe5631df7fc840ac71def03be8fe1c55f2e8de2affe60ea64bb0f083e857ca5a"

  bottle do
    sha256 "2cf2670d76fb022915b80aadd45d449908f4fcf5fe9f73d2db160d105261e86a" => :high_sierra
    sha256 "a3d0d80329854712a37acc5fb5ffc6c4b283dfff1686a3a2ceff891d74437081" => :sierra
    sha256 "9aa42e0f7db81722ce4b01ee1dbce2b8c959626d53fb6920bde0f1588d18187e" => :el_capitan
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
