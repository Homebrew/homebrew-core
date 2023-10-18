class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.131.zip"
  sha256 "e5e1a4ea25fea56ebd62d7b94a089c29e9394b6394ad362762297b7cb31622df"
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
    sha256 arm64_sonoma:   "3dd2385be7ac75fdd8ac50995243257b7bc6b8e4c8985fc0bd36d5bf3ec0729b"
    sha256 arm64_ventura:  "9ac0f66db9bd33a7eed96547fa8275cc21a685d74d5069a40405cf7fab3d52df"
    sha256 arm64_monterey: "d5329ebeff63cf601e7f974232f549c2031696746555852941ef1ed511d4a74f"
    sha256 arm64_big_sur:  "f9aa3578ba6ac20fcf465e8f58b75d8eba8090e85ad151e04e40c233f28217c5"
    sha256 sonoma:         "2b5fc7c437a1f32336049c595b9d93e15aa07b1be5475d8dea08b62cdd376b43"
    sha256 ventura:        "60be3bf339b397baaa7561947c1f2fb61faef03885f87ec952fd338e57671293"
    sha256 monterey:       "a749d76663f5324f19f7b502da23d0b077f214af83f98e7e8762b1f37d47032b"
    sha256 big_sur:        "3f4aff27e5c11914cb9fe52fd5f676989e3bbd1f6bdf634055cbeb3141a7fb98"
    sha256 x86_64_linux:   "82e2d1e4f7f2a11c77143093d4222ff06a8811836b5bd08140c946c5861e91f8"
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
