class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.147.zip"
  sha256 "112e92a40e734566f57f782b61e39b4ebbe9049f0f1cae49893272f59dd096e2"
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
    sha256 arm64_golden_gate: "f7789b187b9138d7a604ace931651103359c7124f79a916821cc134733cab7fd"
    sha256 arm64_tahoe:       "ac051966f82c8d8fcc15bbdfb179479d4f4c5b2e4eaf774a7fd9cc60b6702356"
    sha256 arm64_sequoia:     "e5a7cc5cdeda86ec221a015cff01c3e8bd94a6e2618aae04e2a0114695ed0272"
    sha256 arm64_linux:       "bab8f147af658942102765070caedfe2136c853c2fbf3513941a13ba4ce07ec8"
    sha256 x86_64_linux:      "96188e888bf686d35b80dd809852ab4de81888e0aaec5449d1c724d6f4835305"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@4"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system bin/"soapcpp2", "calc.h"
    assert_path_exists testpath/"calc.add.req.xml"
  end
end
