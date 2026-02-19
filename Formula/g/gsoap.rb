class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.140.zip"
  sha256 "46a2a91f1d9fd756fd6e6e3b82deb673e3f7cc574d234c91132cfaf90449d3ab"
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
    sha256 arm64_tahoe:   "cf4c97610f77f2c9b5f06255f96e650e2e57d74213b02d4b385e55cf4824fe66"
    sha256 arm64_sequoia: "df7e2eb67ed893096372b8e6dfc5b7d9e771277a11f1f7b5e680010301cd7854"
    sha256 arm64_sonoma:  "dd104c0b5759a1c115877f2af1cdcf83c3714cd61b82038dc5fc50e38ed2c2fb"
    sha256 sonoma:        "2be8de110f88781e1d8081810afdfc548332b1df79589c1b437790726003f178"
    sha256 arm64_linux:   "62c8b487153acfcf3cbec5f45e48f0df8b83a5b26881a75aa001e52cfc06683d"
    sha256 x86_64_linux:  "7edb24c0af61112ae66a364bffb97af20aed42e7da427ee7372de99d7819d193"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
