class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.104.zip"
  sha256 "60fcd137c59a7640470f873d9a0a29c62896a15e8517a2f5a03eb2d7eebc0c52"

  bottle do
    sha256 "a180cea83603a954af06249e89902c1ce1870a2a173ca5fcb38256dd1f166699" => :catalina
    sha256 "8d76726a053764e6469eb396a5dc841b0652bdf7a0d0162eb0f1478d30602da0" => :mojave
    sha256 "5cba55bdc1815a5967bd20ffb945a83daff49c06baf99786c57bac21d27486ad" => :high_sierra
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
