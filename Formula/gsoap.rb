class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.88.zip"
  sha256 "effbf8a4533917b9eb3aa0e79db13573ef52e768158f5b4eb93d49b0c5cb2fa8"

  bottle do
    sha256 "cd9df48d85986e99251ea10ea4e77f5610b8b7929ab44eb2388b8d0cd5b49821" => :mojave
    sha256 "50eb985b1ba0297c358d534b350ab2f372ed932b00fa3c969b66b567434f5d71" => :high_sierra
    sha256 "bab260075f9c3bdc0ea89492e46abbdd1f283bc9fd6be76b9f446786ab5cb2ba" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel. However, issue persists as of 2.8.88.
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
