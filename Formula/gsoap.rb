class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.125.zip"
  sha256 "d7f5c71bda7e032c1819b53daa7d8bb531f9275aee1851ccb9a89f27e29e300f"
  # Parts of the software are alternatively licensed under gSOAP-1.3b, but this
  # license is considered non-free by Debian and Fedora due to section 3.2:
  #
  # 3.2. Availability of Source Code.
  # Any Modification created by You will be provided to the Initial Developer in
  # Source Code form and are subject to the terms of the License.
  #
  # Ref: https://salsa.debian.org/ellert/gsoap/-/blob/master/debian/copyright#L7-26
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_ventura:  "8ae72f5a869fbc40c6f15450c37a46b05db0c494d339ade75b9a25aa1c397417"
    sha256 arm64_monterey: "df2f4a61fdd83bfb228c1812b4139ab8c31025a7a19aa3c9bb021b0d5b6c2300"
    sha256 arm64_big_sur:  "b894ca19436b1fecb537a2872786809b0f61afc683ca1f5c2e928bf78d63c05a"
    sha256 ventura:        "cdfab81f973c13b116aca05af37f399c3aa05161e29b453d15a92765490ffa06"
    sha256 monterey:       "58ff66ccf30a497abda50598d1298fbccf657b161c362301c6fad1968a758bc5"
    sha256 big_sur:        "f829846214c1157e6902a0efc8f126395428753aa4793a6d64bb60e787fe1f4f"
    sha256 x86_64_linux:   "9845cc9f94df31097c5a9b3006619b9aedfeb1343b714c0eb0b0649fd7ce2d74"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
