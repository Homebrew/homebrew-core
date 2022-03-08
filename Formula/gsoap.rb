class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.120.zip"
  sha256 "a6d6ae3e47713ff679ebd191eac678f0e2d6c409cd4367ec6f6fc6e3e7dd740d"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_monterey: "5d506ef7c623e517059afb57a339650058fb9b77d638273b637ee0b7a8414144"
    sha256 arm64_big_sur:  "be36e14c8cf83f90232de3379c2da8817991a1c2cfbfab0dd4aaecd4e5836e1b"
    sha256 monterey:       "8968b0bd6bf1d371b63965972021918f9d1ea8b2bf36076b712f26c9570e46b5"
    sha256 big_sur:        "a17a5bffe8c0d3fddccdc0db0174e40c116e77083ac41ee254812025f8ba31cb"
    sha256 catalina:       "d64269092774ff12bfa7010ea741774114fb5b7e6033cd535eb84e290d2a74d8"
    sha256 x86_64_linux:   "af0d697ca7521ba0ca234573333f608e1679955d817dc1784aaebf77911b685d"
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
