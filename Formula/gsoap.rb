class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.88.zip"
  sha256 "effbf8a4533917b9eb3aa0e79db13573ef52e768158f5b4eb93d49b0c5cb2fa8"

  bottle do
    sha256 "f624dbbbdc3d9e71be190804f9c891278620901bd913aebd41c47a5099de9bd3" => :mojave
    sha256 "57a38fb1b5628005ecfdeb9cdc4bc5a24dd18541f62afaa8a80b492ad194912b" => :high_sierra
    sha256 "fff80c53d7213544764926b9906be48fee7babc23aba9e3619064924d4b6c4fc" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel. However, issue persists as of 2.8.88.
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
