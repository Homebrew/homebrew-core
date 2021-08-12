class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.116.zip"
  sha256 "2a41e42aaddbcd603b99004af95bb83559dbd4fd2d842920f003d24867599192"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_big_sur: "230a66223a335f4b143aadb242d0f4a212f879e255e45f9007aaa97c9b697875"
    sha256 big_sur:       "1f528f320803fd3ce59b68a8da56be641bdcc1c0c98ed0fcc82e571d7ca9dc30"
    sha256 catalina:      "ca600b6086e751ff0823b322e2e1112787bbbe75851d95f7b8364dea6e4c6058"
    sha256 mojave:        "027e14cc3144ddaeb6818f74368bddf9b2377b227fac876ed13d1d3d720ba502"
    sha256 x86_64_linux:  "9344ec12f9a83d221fed538f998ed6def39701e7cad1b3503dba114b04276a0b"
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
