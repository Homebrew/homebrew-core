class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.126.zip"
  sha256 "b65190ebf8c2517d6fafbdc2000bc7bc650d921a02f4aa53eb1e3df267592c4a"
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
    sha256 arm64_ventura:  "ad567dacc24fe56c847641ee12778a750f606142d7cb0909eb5cdb28e9dd74be"
    sha256 arm64_monterey: "61bf675a7481497f9bcc7ce9ad0d902dc80f819498edb94cbdafd4f52d30b6a2"
    sha256 arm64_big_sur:  "6f6298244fccb9cb0fc17ffd001a560ec1dfd607dee10ceaee343d84dfccb75e"
    sha256 ventura:        "d1b3a80e867849b049ca8b617b977effa5e33a34fae0e30f926567288acd1ae5"
    sha256 monterey:       "be56aaf5a9f8ebadf22c9cae37f4c6752948df8b46c676241d634fda6e7664aa"
    sha256 big_sur:        "aefd17440ba3a368c7b16632f962ed68c34e62a8fa7ab7d025fce640b3e85c7f"
    sha256 x86_64_linux:   "7530059c686521d89b7c19552efb6e48c9581fe4d80f3751b8bd9fa03309e4b3"
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
