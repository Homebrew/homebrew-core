class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.123.zip"
  sha256 "e018500ac942bb7627612cc9a8229610efe293a450359c413da1a006eb7c193d"
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
    rebuild 1
    sha256 arm64_monterey: "1c94359903d3ba4209032859ee9de3796770a727f71ef1816b26aea52564341b"
    sha256 arm64_big_sur:  "55cb4f1b8dc2b473f08ad10669a9c50d1df270c41b1a2e80e4d85c8339443ded"
    sha256 monterey:       "ea1dc19b64927f5ced7ace5733068b65b52185d9d5dd8acc47873ad654ef1773"
    sha256 big_sur:        "d4c16542ff785bf25cc1043d7c659ac6d5c7b7be9885db216ec224247cfc913a"
    sha256 catalina:       "84431c27cac489061a0f24e507ccc36690e2cb696d5e05a62ac13e834795566e"
    sha256 x86_64_linux:   "6966f95eb5cd051a081b744e272adef135570a52f3843163fa58a18378aeec7c"
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
