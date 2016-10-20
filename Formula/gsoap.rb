class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.36.zip"
  sha256 "20f70db768062e094ec3749073bfc4103cacaac8cab2cdbd624634ae496eef21"

  bottle do
    sha256 "0f12a3f2fec76aff29c79b5e7f42ab7059e600cd7c09ccefa1708a04dbb241dc" => :el_capitan
    sha256 "bc1fc03b48a1f820a5bc54dd649dcc576699cf878691cd645512b6c5633e3db4" => :yosemite
    sha256 "300a97e3c6152f973356b49779ac332940a25f8418486ba59aac0e7501d25b9b" => :mavericks
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
    assert File.exist?("calc.add.req.xml")
  end
end
