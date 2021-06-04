class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.114.zip"
  sha256 "aa70a999258100c170a3f8750c1f91318a477d440f6a28117f68bc1ded32327f"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_big_sur: "1311ed76cfd1b4fe0a477f83e15c6a4acf294b7b8d7a11c0c61e5dffcb3c6a38"
    sha256 big_sur:       "4f0d9e8d8cdc0621ebd2794ca9919308c83814241ad0dc1debe8eb8d44577024"
    sha256 catalina:      "9a9488933737f3f9018f5d54cc3cb292dff93e801734ad8651e93be60e1b0b33"
    sha256 mojave:        "e91456ed8510a9b53aa6b015f80b666d1173e85b3c389e745843f24beb24a754"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
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
