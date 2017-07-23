class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.49.zip"
  sha256 "520909edb975ec7fc63aa1b404993a79c1b8f6a0d80bca588c03cfa5fec12410"

  bottle do
    sha256 "50736e6b139c3a6e2232f3bb9f430998e7d291ba61ad8e6cfe8c7fb5eef033c8" => :sierra
    sha256 "0d777e8f9fb5485fe382d2ca3e0fd0e6bacaefd38e979adc1cb3bea7a399e77c" => :el_capitan
    sha256 "a002421ea5bf4ac0bfddd0fe8bf31fb0a11795d3c4d554f8aa0fccbab6291202" => :yosemite
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
