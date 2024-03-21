class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.133.zip"
  sha256 "93e124302c5775e115e661af2bf4e1f07fa05aef14f58ce65b5c27c833afe279"
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
    sha256 arm64_sonoma:   "87dcebb85bba05fd93bfbb3905c7f435353c4fd57a9f95c9c241704cd2faf9bd"
    sha256 arm64_ventura:  "f57c7c9b843ad0604cbb4c38dd7ba754f3b0b4ab7557060205a68737310290eb"
    sha256 arm64_monterey: "55e9d5abe46e475bb43f9b77c6b2b0550ce09c93281e1e695a35820788dae275"
    sha256 sonoma:         "6c5d4c8ba7d8292bba9d5b3cc1aa6760faf0a3a13cd56e1aa86e6ec1b3aad9d9"
    sha256 ventura:        "d0443e48a7b7858cc2a40093c49186983238bd7906514fb94653263d2ef9eba1"
    sha256 monterey:       "6861e4f06441fda42d984164f8f6900c6dcfb13ba8a3f69ffa2259298d47a893"
    sha256 x86_64_linux:   "a4d5c053275de3daf2c31776b21e577141250abdef8984b2089f99ef574f03e8"
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
