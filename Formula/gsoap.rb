class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.107.zip"
  sha256 "ebb58db4606f505ec97a66cacd3260330b937fafc2bfcf529fe4c9653f042cd4"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 "9a034d1b1399ebb55b43b67bd6ea4724c67c52c875774380186e281167a53e86" => :catalina
    sha256 "412dd85f841a384f0071c875ec1d26c53ddd8216baf67a64e75c3c6c835d3fd5" => :mojave
    sha256 "0297e50a393842fac0d56a7b7d450091eb422f90653f9673701832f7e4e94bca" => :high_sierra
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
