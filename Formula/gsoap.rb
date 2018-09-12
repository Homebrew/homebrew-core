class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.70.zip"
  sha256 "5b6933394ae1c76faa9a4814c44f74fc8aeef521b57f18d62ae952ecf38d0edd"

  bottle do
    sha256 "c5d761c13270f868f1fa8117a726c51efaf22a67daf89b1b8149ff7c9a855292" => :mojave
    sha256 "4ad420be497835975ba852db4926094db298aebd8cd3ec1752ff410d585772f7" => :high_sierra
    sha256 "3bf37d24a2ac2de5d5e68a1366e17112a34c123fa4b3375c6ffeddae82f47481" => :sierra
    sha256 "ba21b07c74d4976cb1a802b12dbbcb4233fbabf4592caad65693f929af797be2" => :el_capitan
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
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
