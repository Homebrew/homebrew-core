class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.109.zip"
  sha256 "27de421db6f8abfc443f2e1d5ccdcbd7e6373095b2c72df2b17f50a9c5f80d14"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 "412cf27cc9ef324733a4d8284de8fffea16dc51d5b735b96b79a4d21faf0dd0c" => :big_sur
    sha256 "5f12a8bebb946fa4dce4cb45a527234bbb8df08a7b9c59c0a2c3d2b0bcb06703" => :catalina
    sha256 "c46221dc8ba576838765c1bac00842da66522d1f8d1c2bee9ceefd7ff30b8c93" => :mojave
    sha256 "e179ecd3f4b21a71e25f614211f3bc9476bc8f127d8d034c98075e0b01e884db" => :high_sierra
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
