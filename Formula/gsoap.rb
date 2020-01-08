class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.89.zip"
  sha256 "d9b10ca2611b00932fab98cbf67b514ddad24f22cbbda91d9d68ea45821c54f2"
  revision 1

  bottle do
    sha256 "3a1e9b3f413512feaea7436654afef10fe166e57a4c6f9f181250792118d09ec" => :catalina
    sha256 "57b1ed5d8d8b6f38db767f957b75dd05bacb1c168da6f75f2202e9995580bede" => :mojave
    sha256 "4dc18439df3f8f79ecac7eb2438d8937f9f6c5919bdd383b945660c8a398c2c7" => :high_sierra
    sha256 "95d559743a7f807d298908e69517d9c2e11d1c3aa12282712b4b73ac41e12fb7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

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
