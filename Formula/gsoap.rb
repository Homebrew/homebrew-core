class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.87.zip"
  sha256 "0d117633cb973dbd46a0bdcdcba74c67485aa9bc62b065e0ca621fdef9425dda"

  bottle do
    sha256 "18df1341d4ed565916b1ccc8228348c5581de74b9f1880fb9721533895d69116" => :mojave
    sha256 "b0fac6a89c05a524f02fc1f8d5573d560f6d0cea9f4e0929f0a5cbe06bd27359" => :high_sierra
    sha256 "ed0662e80a9c81e063f54b4d0cca5cb67f30dc9f26db0b5fcc6c444e3454fffe" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel. However, issue persists as of 2.8.87.
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
