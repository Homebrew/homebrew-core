class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.123.zip"
  sha256 "e018500ac942bb7627612cc9a8229610efe293a450359c413da1a006eb7c193d"
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
    sha256 arm64_monterey: "ec7b9271c31cc8504402874e0d7f7c3bf7564a2e05883b94c8c963389f91d69e"
    sha256 arm64_big_sur:  "e32d905f4751e4c38961943c27b3553f9c14e170a82435a506acb6781332679b"
    sha256 monterey:       "45dcb159e296ab5aee0255754377eb0a3059978403e310f43dc544bd94fff272"
    sha256 big_sur:        "87019a8e6495fc4bfbb62ce4bd790551acf2a9ee127b064c78564efbef9a459e"
    sha256 catalina:       "c112370915365358a03f2fbda1999e93d23611f6d918b470f657c246fcbeb167"
    sha256 x86_64_linux:   "17395572b2c0f3a05fddb88b8402bc79479d9c8436fb40a8d5017670869d6834"
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
