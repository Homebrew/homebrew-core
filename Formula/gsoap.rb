class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.98.zip"
  sha256 "56460362ca8f9decdf880d82601e50ae13fb2185582a704b037060acacb7fc3a"

  bottle do
    sha256 "76094b7f58f3c381de22411f792540bfe1c6503631446c255cbfac18f647a394" => :catalina
    sha256 "57d40b71e75d9eeee1b477af4716b818d48db4c862b7eea59dd5e9a8b5ade318" => :mojave
    sha256 "82d0960728f95d9750b4bc1fd26f80703db8ff69da0ba1a546b1c136c95f544e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

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
