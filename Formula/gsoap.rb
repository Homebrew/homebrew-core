class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.53.zip"
  sha256 "996103a8bcb205f126316dd3e5968afc1230426a9233335831b1c527066c6558"

  bottle do
    sha256 "b9a255fc8d5308cf1189394fe4383fdc4253718fcd86b91a1f54b3434391186c" => :sierra
    sha256 "195105b8af7c68e78713eac4f49068f028b73449dfcc6c78dc4dc7550f437537" => :el_capitan
    sha256 "d2a8ee22de241281fad717a35b3dcbf85c133a2cce9c7f393315110024b09518" => :yosemite
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
