class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.103.zip"
  sha256 "afe2ba08d2fa56adc3c774b6741587203a72140a255346e9947b8d2ee6c7d4b6"

  bottle do
    sha256 "6721742878f94c04756d18ca5d4555d43cfbae6d33add3a1afb4c0f20c0c3684" => :catalina
    sha256 "a6c9a0b6057e9117b678a0f9232d33f88770cf838365fbdbc628b7d9fc92b8bb" => :mojave
    sha256 "0baeffa7065bfafc8572ff3bb23cd85cf82b49aa1fe9f25f3b02171d1f1100dc" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel. However, issue persists as of 2.8.89.
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
