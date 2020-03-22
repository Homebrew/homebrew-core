class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.99.zip"
  sha256 "c1c99a64eecf96cfd781a611171b58a39326f5811eb98c619aa7c54ec7bcc84b"

  bottle do
    sha256 "f0b1a85c94b996b9200f29df9b421b6b0d5f6d4df6465848caaff60c2b386fbe" => :catalina
    sha256 "7464b26728c66eba6ef312b59e1b30c8bec3ea2fbe41d37d9e7692c8235b0458" => :mojave
    sha256 "78db6e81d2d963b09b83c69a89fedfdebcf849196b5936e2f22eef98210d1fb2" => :high_sierra
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
