class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.106.zip"
  sha256 "4e74838baf5437e95ae17aa3efb48bd0621f483bff4424f6255fcf327ff80765"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 "155b8a6caafea00e17d03f713dc450359c37d7c193deff91a19c25a4045cb1da" => :catalina
    sha256 "ade4c75fd5bc70122bb5925397161bd8dd4d39ea4bd3e30e7ca0ef8d0beef4aa" => :mojave
    sha256 "b8c9ca987c521a6ce5513fb2c1617b137f47e3f061990bca7b88a196d1402be1" => :high_sierra
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
