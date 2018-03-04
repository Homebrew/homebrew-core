class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.64.zip"
  sha256 "221213dd9ba398e4e568ae24d545607c4177f04d3920a6195d9db66a64a69030"

  bottle do
    sha256 "f679d033483903a9be5ed20f39f514439fe8652f9864a08fd361ef7f9a49a7ee" => :high_sierra
    sha256 "5b1ad4ede9de7834fcd144a2212068d67851c7f41eaa796ba40ddcc254673aa8" => :sierra
    sha256 "e0f5e6acf7f21b5505cff2e230e3e9e196f3433d595b2072b4f46a494de2f212" => :el_capitan
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
