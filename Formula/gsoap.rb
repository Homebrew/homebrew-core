class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.51.zip"
  sha256 "3e7bb24a9e492f5cb86daca34054c9787152f1d7b70add36b789d03816d5ffa1"

  bottle do
    sha256 "49baf72dc4a7d63e77c5bb7a2eb4bdfb4ef04f7638dfa26907fc23f60c183dfc" => :sierra
    sha256 "9fe476a18533a9eeca977d1e07a13ab53cdd156f9abfa5e5a190eb3bd7fd8c07" => :el_capitan
    sha256 "85669833c1ae34ee8163ca25ae0409045cc571a967a1a123a5a44b616d9170fe" => :yosemite
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
