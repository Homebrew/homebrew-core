class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.110.zip"
  sha256 "ec8826265faca3c59756f8b5d637e06b7f4ed4a984243caa3f53db4ec71e577a"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 "93fe2a7aa626ca66e67bba197f1fffa04fd43715b8ac44234c21d753db0a3f2c" => :big_sur
    sha256 "a16b4576ac353965e5dfff452e42f13fd632d6ab71e6411fd9b4031cd30228de" => :arm64_big_sur
    sha256 "c2bf0fe4477d58fbbd507b01892e8e52df4b79a905ed1c4c7a3fbbe3b4f4e13f" => :catalina
    sha256 "3947a0297c9b3ec635ce7951bcd622b1c2ae8f2c03a7149be2c001569c304961" => :mojave
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
