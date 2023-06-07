class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.128.zip"
  sha256 "334337862242805c1072a7f5103e0a4edf4b1524879715da4d8c387c395c9ea6"
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
    sha256 arm64_ventura:  "1bcb5820cf323d570abce5f542aed2a1b48bd658b95a2c94651c99c9b7014975"
    sha256 arm64_monterey: "3c1a899dbbd6a6b93ac23bdb740bfe54fc377d7e3bd461ed2aa97fbfb3353141"
    sha256 arm64_big_sur:  "a55320035d898a79a79b91dc0c614ce6240508cbe212c312efa9e62a28c80429"
    sha256 ventura:        "7d14475e87eb3e327350c0bd28cc32e0caae184d253b05f9261bb280f298225c"
    sha256 monterey:       "a2f5266ef3e5b3ce4b506d0bf6cee83f4ddcdfa34d0e8480e0723f4b64023368"
    sha256 big_sur:        "047f7f49c7e4a45200b2b12eff0a12a610c8d0ae02e2898739bbd50e19a971f6"
    sha256 x86_64_linux:   "3b8f385fc54d359bfa305b0ffb8b21e1067d845765e47e57e6478cfe761d149b"
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
