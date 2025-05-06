class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.138.zip"
  sha256 "5ddd63eebd6a08e1838e93400a843975c65ae77e09a95276f9adf166d3ca6f74"
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
    sha256 arm64_sequoia: "dd050b688db6f6dc0afb179015be76a256a2d91fbee487bf7ad06756e9838752"
    sha256 arm64_sonoma:  "5181ef3b7f16cec46e7a951898d42cfe01a1d424ca742752aeb7a9832ed80485"
    sha256 arm64_ventura: "0c002ce067077f15d7aa1571866ca07dc4cd1c183019364bc87bfdc203440a29"
    sha256 sonoma:        "ec9100abcefd7e4de6675a1f142db49da2a5f558c8dfb48a588a32add9e762eb"
    sha256 ventura:       "6d51669692bf617de0ae562d380c1d1b545bc99609db68bffbf004b1e1fbccba"
    sha256 arm64_linux:   "d85ffb3b69c1b3256cf621553c02b2230e2d93500d4965c887f65bd1198f93a3"
    sha256 x86_64_linux:  "d4ace7c9b06feba5c0780ca342cf53daf8efb0eac45017ee02f8bdb469dac04a"
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
    system bin/"wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system bin/"soapcpp2", "calc.h"
    assert_path_exists testpath/"calc.add.req.xml"
  end
end
