class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.106.zip"
  sha256 "4e74838baf5437e95ae17aa3efb48bd0621f483bff4424f6255fcf327ff80765"
  license "GPL-2.0"

  bottle do
    sha256 "0512965f3153e3669a52135cd1a9506b72ef3e9492b79386e028cc7ac16d9770" => :catalina
    sha256 "791b245081c3b11482a04a813536011e4c4bdaa2b79d4fa5bf7f5d13f22330b3" => :mojave
    sha256 "97233572e8dc3d26c99e42ebad04bf57d1344ebcb59ab505c2d605c0b88101ef" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
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
