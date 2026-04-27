class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.142.zip"
  sha256 "6d7196bd6591ec2977474c681e351b4a33eb5c2d64c9e2e6727b004f330b3752"
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
    sha256 arm64_tahoe:   "096bcf810d9c92e2e2ff61a4873cd767627b898b4861bc5f560da0fa0674acc1"
    sha256 arm64_sequoia: "7cd7ae2e18566260d6ca0c4c0f157e21e22bdcaf60646d9d0f85d5a3e339c513"
    sha256 arm64_sonoma:  "738c569c1d89f656ac34f7fccfd528516af6006b82d05d91a79109e7ecfc57d8"
    sha256 sonoma:        "cbc2700e147dd8576249dd455595a191e6d7f5edfc6b9fe40a933de47f75439a"
    sha256 arm64_linux:   "0f0b74425125a679e0a5e80006b20f9f93e14f25f56f1640215e99798289f48a"
    sha256 x86_64_linux:  "a44fa33a56032c179338710e92848a61447323f5a57209a14ecffaf7c7582921"
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
