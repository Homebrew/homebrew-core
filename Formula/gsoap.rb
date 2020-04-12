class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.101.zip"
  sha256 "23173811c3295a256a5591fa97490dc4754784aaa25102bde418890e5621206c"

  bottle do
    sha256 "c911a6839f11d00d4bcf5365ba31efef28bee314d727854c442a7b0a758a4971" => :catalina
    sha256 "bade00f17f752f6bb3a36a2562ad4e60410b8add71759ebce312bc6d1eeca48b" => :mojave
    sha256 "9fba81075ebb8734d66dfc838bf2e0401123628decee1c67ff909b2b05d8af3f" => :high_sierra
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
