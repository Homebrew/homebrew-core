class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.129.zip"
  sha256 "16cb8852ea791a6aec8f0213d619c15eecc8171e0c888f3b0e0c66d3ef78e20a"
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
    sha256 arm64_ventura:  "336540d01a838881db06ec9a0f455f8e1d1098f3e075495d543b11bfa9483c5f"
    sha256 arm64_monterey: "2f665c8b9927763327cd25f7f019317b1f1071c1865c96ea96e4dd694c8388a3"
    sha256 arm64_big_sur:  "d8723d45a12018780f4a33efe910f3a5a1ce82cd72b9723bf00553276922ed7f"
    sha256 ventura:        "012d11a2854080e6f259b5685b8673263d5bd402d518fc486603b22d300bf9b3"
    sha256 monterey:       "30e20cb707f8a385a294a2cd31e0f93c08ef96667f80fa6df2aa89a6784a0ad4"
    sha256 big_sur:        "880dbcb0bf78ccc3b25a950e5828a0463189eba25bce23a3a345431ccdc29779"
    sha256 x86_64_linux:   "e01d2cdaaeb69e3cb49d14d15da4f85d3adf031b2ec52f8eaa05d11b5da7f953"
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
