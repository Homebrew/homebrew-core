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
    sha256 arm64_golden_gate: "ead38fb0855affd09b3390d95761b6559d684c8dfa114f1c9315daabacb9f36a"
    sha256 arm64_tahoe:       "be7eb1048bb841088789d77ccc753e764001bb9808298e9ddfa83997b91f2de8"
    sha256 arm64_sequoia:     "e0003c30392f5d4a8c145af24ad80eba5c58fd8bb1d9051de039296a672fcade"
    sha256 arm64_linux:       "6b6bf10b14263e85f0fd89b5e4b2059d1ae08d074de0f6ebc98430cb57507a44"
    sha256 x86_64_linux:      "da4e77a6375d790a7936202f08abfabe5e87c34c2c5b142269222a4f48857e4f"
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
