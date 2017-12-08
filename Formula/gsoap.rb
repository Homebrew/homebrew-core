class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.56.zip"
  sha256 "10374c8ba119cf37d77ad8609b384b5026be68f0d2ccefa5544bc65da3f39d4c"

  bottle do
    sha256 "303a0ae7b051003bd922f9e00417bfdaf7d3cda51c33cc1ad1f7cd54c39c2b01" => :high_sierra
    sha256 "e40322714045a2128a9634a19754f9a48af0a2a6264ee9f2bca36d78cee89c29" => :sierra
    sha256 "f834fc5ce7c461c7ad20a059bace745e34561947921a1441b371bb80d2b6476b" => :el_capitan
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
