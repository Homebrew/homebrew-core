class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.127.zip"
  sha256 "25ecad1bbc363494eb7ea95a68508e4c93cc20596fad9ebc196c6572bbbd3c08"
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
    sha256 arm64_ventura:  "bdcbf84d17d9d78e392957d9b68c464826fbafdfa09dfe7b0503357d9bec0e34"
    sha256 arm64_monterey: "742210934076cf4dc291fb6b12a8af2f5ee4581ec80e6f3d4758ffd68204a57b"
    sha256 arm64_big_sur:  "c7e41edb56326a6551768c3868a51a29f5121f0fc7a7643abe501be9bc7f0f7d"
    sha256 ventura:        "1a0d9c676c02c2f9e9ef40500409626ff3fa33f5c473f02dc393f5346a90c342"
    sha256 monterey:       "891d92d63d6d172fc0c2b620c97788791e38e23876cb78c01e29c015111e3eb3"
    sha256 big_sur:        "af29247b1ca088e9b9c6a2b8e50e97100c3e0384191a1414188619ab90f92456"
    sha256 x86_64_linux:   "ff119d4896411a7584d9f375c4bc6df00aedbc3d2daedbe40d31ed568385386a"
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
