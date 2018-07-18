class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.68.zip"
  sha256 "2e470f54d89d03f0eba03bd60b7f345003177315043b6406e80e5883437cf649"

  bottle do
    sha256 "5c9a5c05954ca78d9d83130474c76eb91f28ef86c229e1c338f8128df83bc2ec" => :high_sierra
    sha256 "2a4557f8e5302fdd575322039dfe6dfc226621ad3eede8895448e1fc7ac55ef2" => :sierra
    sha256 "75f31bc0fa6377721ffe2b2611abdf25a1dc73d519f5c1a6e26dfe6f712e6fab" => :el_capitan
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
