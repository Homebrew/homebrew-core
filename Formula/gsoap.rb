class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.111.zip"
  sha256 "f1670c7e3aeaa66bc5658539fbd162e5099f022666855ef2b2c2bac07fec4bd3"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 "6a02f874228f9b5eaacd662c71e3589c59a0a2bb1d24d929ea17b0ee7a09a8ac" => :big_sur
    sha256 "b27b5c8ba8cc9bd7bb5bee7850e79abe2a83827a66e07b8ec1616d9e91c2927b" => :arm64_big_sur
    sha256 "cbaaa15033dc9a62aa74195175860bba1201d54a1cf05c809424caa38cfd735a" => :catalina
    sha256 "8474f840a2b849a0779a9d7a54ecf390d4d6cdf2b4898530ca7e4415b31c9625" => :mojave
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
