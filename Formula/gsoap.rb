class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.89.zip"
  sha256 "d9b10ca2611b00932fab98cbf67b514ddad24f22cbbda91d9d68ea45821c54f2"

  bottle do
    sha256 "c3ff1fa1f2475b6d2be36e5a1458e8afe9a97fdf8b01136e924279710ac00fd3" => :mojave
    sha256 "c85976b801fa1ccb75de89bd517d0f715251c069426389cd104935adb2f97dc2" => :high_sierra
    sha256 "ebe95e814107ac48dc3174ed5eeba69097413619a9842937bd637b4f904b3a38" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl"

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
