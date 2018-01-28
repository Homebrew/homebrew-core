class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.61.zip"
  sha256 "99d0dc739773a6042a1f496e8e03e01d49d54acca4e6539ed09aac9287c5239c"

  bottle do
    sha256 "e5356398f8cdbc80fd5d9320f6e89bc6b105df2af5e711983f4bcad7037f2769" => :high_sierra
    sha256 "ac8a2a8d38b1b7e0bd135e807733dc289cffb221b114e4428effbbea0f4f902b" => :sierra
    sha256 "ddc0a3ca085fe3ce4397f69c0c0180b83261d9ca4c5123eedabc3bf664728cc7" => :el_capitan
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
