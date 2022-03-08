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
    sha256 arm64_monterey: "e58bdaca820e0e52871d19f654abd0a5affab9216f3701243f7788d3104f07da"
    sha256 arm64_big_sur:  "a4012ba9470960ce9c711e9c65cb9c29b72ac1dc83b3b1f2ab12bcfe4c57e846"
    sha256 monterey:       "34cf51a748e4e9209af9624ade47a7d1109af16cb61f80539ca9a2e39b871891"
    sha256 big_sur:        "0f78a3f1220528590766c8a81b08fbf7b7b8302a348a1d1659593596bcde8fa0"
    sha256 catalina:       "ea4244f8503a5f3faa3df546b682d7cfe683cfc8ee8d8dbc93213134cde02de4"
    sha256 x86_64_linux:   "9b242046579d639fc3b3ac5933e2bc9645146b4ab2d5ac6d40b64776d3b78ac5"
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
