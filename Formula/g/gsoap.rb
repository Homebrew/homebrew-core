class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.134.zip"
  sha256 "63478e555c0ccde0164f055ff605b02805db0abc6712a04bcb14cb617b047218"
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
    sha256 arm64_sonoma:   "b094ee384816a379d3b58128f10ef3eedb20d3c77b527301c7c3fbf3963422c2"
    sha256 arm64_ventura:  "16cf74dc8cb9885125a567f1aa6e965e97bc78813e132b3a8de3dffbbc90369f"
    sha256 arm64_monterey: "233d735822dcbc4ce82a5d458c8e06c3ab749dfd29e23a6c9ab29ffd55b015af"
    sha256 sonoma:         "7444dae5cbaa7877f623223239df03c532efd3ed0b62859250036b1fd843027a"
    sha256 ventura:        "f05ee551a47d070b000be3354498b82d65f70750ea063cd2a103a6bd05352698"
    sha256 monterey:       "7a5c6a645094a6580357509a0aaa1b441a5c5785f9dc2dbba969abd761f6307e"
    sha256 x86_64_linux:   "5297d98fe7baac09257e6027c7e43c46617737f17a60f62592507165db0213f2"
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
