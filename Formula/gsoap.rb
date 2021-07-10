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
    sha256 arm64_big_sur: "b9023155e61e18f169163e0d17e4ea130f95dc6ade6bb89e9a56e8458d6b8e54"
    sha256 big_sur:       "bfa8373d47f03c3461f7d78f9098540ee6417ae65105c01d0a1d1488a60f1c92"
    sha256 catalina:      "bb792ad3a6cafe63c81bcdda836be6c5f7968fc2d797852ea7511b71ab0bb478"
    sha256 mojave:        "2d38a218fb7c0cf4f7aa298af3d2cada1a47b84d5e8dc22cd7ed7bb5195ac250"
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
