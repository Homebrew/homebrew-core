class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.130.zip"
  sha256 "5cece2b1829f3a94c1448d8e763e54dcb16f055710044e6f450d2004f2e5a3df"
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
    sha256 arm64_ventura:  "9328b3604c9cfbc9fc0d1a882b6b4f310564e3044b420047e472e837929665e2"
    sha256 arm64_monterey: "7aca43b23f7e2216756dc05658a795f219fc685eb721c001bac6ce7d94ad762e"
    sha256 arm64_big_sur:  "f1b8e4fc16d648066f13f0eebb7dbb29a7774737e202d1736e75b70e11ecf5c1"
    sha256 ventura:        "a1fe540e7c4f7cb3a82e76d2b3a54ce292b44211665f10e78987c0c58bab5249"
    sha256 monterey:       "2ac33cc7780c4223dd0328da4b008225dfafc19d03758a841c43ba862b860bdc"
    sha256 big_sur:        "8a0ab9739c3047f78b2b95a1d2d3ed76b673ac4b236d7ee5791304dfda7f65b5"
    sha256 x86_64_linux:   "6ef37b632eae953d61870c93a2ee68d7adc83b120c83fc08c540e7152ad7a5fa"
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
