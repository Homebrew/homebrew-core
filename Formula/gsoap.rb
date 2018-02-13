class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.62.zip"
  sha256 "477b349a4cd9f27adde31e598b185910788e7a493d52e3eb599768cccb5519c2"

  bottle do
    sha256 "50a1e4b55d84cce7c692f860eded7b2f98fcae468ed0a9315841cd9df862df8a" => :high_sierra
    sha256 "8bfc18b2779afebee904dc39be4e2e86ddc181ed147956b45f7043d4b565fca4" => :sierra
    sha256 "4e6647382b0efd6d54f3e2bb4f9ea4a9ebcbc6b35d40eab8b38bb690c55e89a3" => :el_capitan
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
