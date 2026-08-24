class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.144.zip"
  sha256 "b981818fbbd4bf9f6f4feac03136800f6e16a7d0b7515924ff7a2661ca26e581"
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
    sha256 arm64_tahoe:   "b44173acc9d4239b545022dd3c67abf1c0d310d98ba55218d584ebc1ab168f27"
    sha256 arm64_sequoia: "3cae3624a47f799be9a4c6c5ac5cae8a65689ef5b238a639133f0bb98ee451d0"
    sha256 arm64_sonoma:  "ed1d008f687d65fa9152195add0c469aaebe441d95b0207cdefd8d40247f3d76"
    sha256 sonoma:        "aba4bf0ac92aa3a4693a231b15cddd355693210b7bfc291940b66e3d205022e6"
    sha256 arm64_linux:   "9517d9caf4f11885b812101ddf212e17928be16e5d2e9352950f5a29c56b2c30"
    sha256 x86_64_linux:  "16f3e88d4b279f15f67fcc5c71a3ae07b1b06595f08ebc89bb179f0093eaa7a8"
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
