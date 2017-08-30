class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.53.zip"
  sha256 "996103a8bcb205f126316dd3e5968afc1230426a9233335831b1c527066c6558"

  bottle do
    sha256 "8c4a14094ea09d2f25cd31be8964fec1a3489e4b7c2e1f1a8d636ae956ed732b" => :sierra
    sha256 "f407b8d3b154e6214356bb98aafe1cafe8e24e131c5b4a7d4b73c2b0f8d00c15" => :el_capitan
    sha256 "81322c863c38cd8c7b90e7043f547cc6b412ff9684306ecf4fa939f21149c41d" => :yosemite
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
