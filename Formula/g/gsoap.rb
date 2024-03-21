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
    sha256 arm64_sonoma:   "8acc579430f4ded53206fc1414c04a59ad072081d8c2aa2a79c905206c38c224"
    sha256 arm64_ventura:  "dea0d3df2a060f3f72df1217350d3ab4cea035efdc94aa64e6670c95f737915f"
    sha256 arm64_monterey: "7768a71815d15ef467fc084b84aecbb671170beabcc6ed420869d1824547a02e"
    sha256 sonoma:         "b51a5d29696e56ece31300dcc23c03170f0329d7a3b653f9bc703102c0d3f319"
    sha256 ventura:        "0cac3c55e200fc04bf422f1379bf4664fc137a8142e7d10fcbdec516cafd9bd9"
    sha256 monterey:       "205338069dabccf5ccdd8d3938fa7934cfd7ad3fcf7de3697f5367b53b52678b"
    sha256 x86_64_linux:   "7e6a34ddac15c9cbeed7cf0147c81033b2cf9a96bb997255efc311ebbb4381c5"
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
